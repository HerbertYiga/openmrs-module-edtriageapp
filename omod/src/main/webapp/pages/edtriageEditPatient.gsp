<%
	ui.decorateWith("appui", "standardEmrPage")
	ui.includeJavascript("uicommons", "angular.min.js")
	ui.includeJavascript("uicommons", "angular-ui/ui-bootstrap-tpls-0.13.0.js")
	ui.includeJavascript("uicommons", "angular-ui/angular-ui-router.min.js")
	ui.includeJavascript("uicommons", "ngDialog/ngDialog.min.js")
	ui.includeJavascript("uicommons", "angular-resource.min.js")
	ui.includeJavascript("uicommons", "angular-common.js")
	ui.includeJavascript("uicommons", "angular-app.js")
	ui.includeJavascript("uicommons", "angular-translate.min.js")
	ui.includeJavascript("uicommons", "angular-translate-loader-url.min.js")
	ui.includeJavascript("uicommons", "ngDialog/ngDialog.js")
	ui.includeJavascript("uicommons", "services/conceptService.js")
    ui.includeJavascript("uicommons", "directives/coded-or-free-text-answer.js")
    ui.includeJavascript("uicommons", "filters/serverDate.js")

    ui.includeCss("uicommons", "ngDialog/ngDialog.min.css")

	ui.includeJavascript("uicommons", "model/user-model.js")
	ui.includeJavascript("uicommons", "model/encounter-model.js")


	ui.includeCss("edtriageapp", "bootstrap.css")


	ui.includeJavascript("edtriageapp", "filters.js")
	ui.includeJavascript("edtriageapp", "components/EdTriageViewQueueController.js")
	ui.includeJavascript("edtriageapp", "components/EdTriagePatientFactory.js")
	ui.includeJavascript("edtriageapp", "components/EdTriageConceptFactory.js")
	ui.includeJavascript("edtriageapp", "components/EdTriageDataService.js")
	ui.includeJavascript("edtriageapp", "components/EdTriageEditPatientController.js")
	ui.includeJavascript("edtriageapp", "app.js")


%>

<script type="text/javascript" xmlns="http://www.w3.org/1999/html">
	var breadcrumbs = [
		{ icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
		{ label: "${ ui.message("edtriageapp.label") }", link: "${ ui.pageLink("edtriageapp", "findPatient?appId=" + appId) }" },
		{ label: "${ ui.escapeJs(ui.format(patient.patient)) }" , link: '${ui.pageLink("coreapps", "patientdashboard/patientDashboard", [patientId: patient.id])}'},
	];

	function sticky_relocate() {
		var window_top = jq(window).scrollTop();
		var div_top = jq('#sticky-anchor').offset().top;
		if (window_top > div_top) {
			jq('#sticky').addClass('stick');
			jq('#sticky-anchor').height(jq('#sticky').outerHeight());
		} else {
			jq('#sticky').removeClass('stick');
			jq('#sticky-anchor').height(0);
		}
	}

	jq(function() {
		console.log("jquery is working");

		jq(window).scroll(sticky_relocate);
		sticky_relocate();

	});

</script>


${ ui.includeFragment("coreapps", "patientHeader", [ patient: patient ]) }


<div class="container" ng-app="edTriageApp" ng-controller="patientEditController" ng-show="loading_complete">

	<div ng-if="debug" class="panel panel-info">
		<div class="panel-heading">
			<h3 class="panel-title">${ui.message("uicommons.patient")}</h3>
		</div>
		<div class="panel-body">
			Patient Id {{edTriagePatient.patient.uuid}} ({{edTriagePatient.patient.gender}} age {{edTriagePatient.patient.age}})
		</div>
	</div>

	<div id="sticky-anchor"></div>
	<div class="panel panel-info" id="sticky">
		<div class="panel-heading">
			<h3 class="panel-title">
				<div class="row">
					<div class="col-sm-1">${ ui.message("edtriageapp.status") }</div>
					<div class="col-sm-11">
						<div class="progress-bar " role="progressbar" aria-valuenow="40"
							 aria-valuemin="0" aria-valuemax="100" style="width:{{edTriagePatient.percentComplete}}%">
							{{edTriagePatient.percentComplete}}${ ui.message("edtriageapp.percentComplete") }
						</div>
					</div>
				</div>
			</h3>
		</div>
		<div class="panel-body">
			<div class="progress-bar edtriage-label-{{currentScore.colorClass}}" role="progressbar" aria-valuenow="100"
				 aria-valuemin="0" aria-valuemax="100" style="height:50px;width:100%;">
				{{currentScore.numericScore}}
			</div>

		</div>
	</div>


	<div class="panel panel-info">
		<div class="panel-heading">
			<h3 class="panel-title">{{edTriagePatientConcept.chiefComplaint.label}}</h3>
		</div>
		<div class="panel-body">
			<textarea class="form-control" id="complaint" rows="3"
					  ng-model="edTriagePatient.chiefComplaint.value"></textarea>
		</div>
	</div>

    <form class="form-horizontal">
    <div class="row">
        <div class="col-sm-6">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">${ ui.message("edtriageapp.vitals") }</h3>
                </div>
                <div class="panel-body ">


					<table class="table table-condensed borderless">
						<tbody>
						<tr concept-selector-row ed-triage-patient="edTriagePatient" concept="edTriagePatientConcept.vitals.mobility"
							concept-label="'${ui.message("edtriageapp.mobility")}'"
												selected-concept="edTriagePatient.vitals.mobility.value"
							                    score-label-class="'edtriage-label-score'"
												score="currentScore.individualScores[edTriagePatient.vitals.mobility.value]"></tr>
						<tr>
							<td><label>{{edTriagePatientConcept.vitals.respiratoryRate.label}}</label></td>
							<td><input class="form-control" type="number" min="1" max="200"
									   ng-model="edTriagePatient.vitals.respiratoryRate.value" /></td>
							<td><small>${ ui.message("edtriageapp.perMinute") }</small></td>
							<td><score-display score-label-class="'edtriage-label-score'" score="currentScore.individualScores[edTriagePatientConcept.vitals.respiratoryRate.uuid]"></score-display></td>
						</tr>

						<tr>
							<td><label>{{edTriagePatientConcept.vitals.oxygenSaturation.label}}</label></td>
							<td><input class="form-control" id="oxygenSaturation" type="number" min="1" max="100"
										ng-model="edTriagePatient.vitals.oxygenSaturation.value" /></td>
							<td><small>${ ui.message("edtriageapp.percent") }</small></td>
							<td><score-display score-label-class="'edtriage-label-score'" score="currentScore.individualScores[edTriagePatientConcept.vitals.oxygenSaturation.uuid]"></score-display></td>
						</tr>

						<tr>
							<td><label>{{edTriagePatientConcept.vitals.heartRate.label}}</label></td>
							<td><input class="form-control" id="heartRate" type="number" min="1" max="999"
									   ng-model="edTriagePatient.vitals.heartRate.value" /></td>
							<td><small>${ ui.message("edtriageapp.perMinute") }</small></td>
							<td><score-display score-label-class="'edtriage-label-score'" score="currentScore.individualScores[edTriagePatientConcept.vitals.heartRate.uuid]"></score-display></td>
						</tr>

						<tr>
							<td><label>${ ui.message("edtriageapp.bloodPressure") }</label></td>
							<td ><input class="form-control" id="bloodPressureSystolic" type="number" min="1" max="1000"
									   ng-model="edTriagePatient.vitals.systolicBloodPressure.value" /> /
								<input class="form-control" id="bloodPressureDiastolic" type="number" min="1" max="1000"
									   ng-model="edTriagePatient.vitals.diastolicBloodPressure.value" />
							</td>
							<td></td>
							<td><score-display score-label-class="'edtriage-label-score'" score="currentScore.individualScores[edTriagePatientConcept.vitals.systolicBloodPressure.uuid]"></score-display></td>
						</tr>

						<tr>
							<td><label>{{edTriagePatientConcept.vitals.temperature.label}}</label></td>
							<td><input class="form-control" id="temperatureC" type="number" min="1" max="50"
									   ng-model="edTriagePatient.vitals.temperature.value" /></td>
							<td></td>
							<td><score-display score-label-class="'edtriage-label-score'" score="currentScore.individualScores[edTriagePatientConcept.vitals.temperature.uuid]"></score-display></td>
						</tr>

						<tr concept-selector-row ed-triage-patient="edTriagePatient" concept="edTriagePatientConcept.vitals.consciousness"
							concept-label="'${ui.message("edtriageapp.consciousness")}'"
							selected-concept="edTriagePatient.vitals.consciousness.value" score-label-class="'edtriage-label-score'"
							score="currentScore.individualScores[edTriagePatient.vitals.consciousness.value]"></tr>

						<tr>
							<td><label>{{edTriagePatientConcept.vitals.trauma.answers[0].label}}</label></td>
							<td>
								<label class="radio-inline"><input type="radio" name="trauma"
																   ng-model="edTriagePatient.vitals.trauma.value" ng-value="edTriagePatientConcept.vitals.trauma.answers[0].uuid">Yes</label>
								<label class="radio-inline"><input type="radio" name="trauma"
																   ng-model="edTriagePatient.vitals.trauma.value" ng-value="">No</label>
							</td>
							<td></td>
							<td><score-display score-label-class="'edtriage-label-score'" score="currentScore.individualScores[edTriagePatientConcept.vitals.trauma.uuid]"></score-display></td>
						</tr>
						<tr>
							<td><label>{{edTriagePatientConcept.vitals.weight.label}}</label></td>
							<td>
								<input class="form-control" id="weigthInKG" type="number" min="1" max="2000"
									   ng-model="edTriagePatient.vitals.weight.value" />
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td><label>${ui.message("edtriageapp.total")}</label></td>
							<td></td>
							<td></td>
							<td><h2><span class="label edtriage-label-score">{{currentScore.vitalsScore}}</span></h2></td>
						</tr>
						</tbody>
						</table>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">${ ui.message("edtriageapp.symptoms") }</h3>
                </div>
                <div class="panel-body">
					<table>
						<tbody>
							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'neurological'" concept="edTriagePatientConcept.symptoms.neurological"
								selected-concept="edTriagePatient.symptoms.neurological.value"  concept-label="'${ui.message("edtriageapp.neurological")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.neurological.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'"></tr>
						                     <!-- getColorClass(currentScore.individualScores[edTriagePatient.symptoms.neurological.value])-->
							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'burn'" concept="edTriagePatientConcept.symptoms.burn"
								selected-concept="edTriagePatient.symptoms.burn.value"  concept-label="'${ui.message("edtriageapp.burn")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.burn.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex=="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.burn.value])"></tr>

							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'trauma'" concept="edTriagePatientConcept.symptoms.trauma"
								selected-concept="edTriagePatient.symptoms.trauma.value" concept-label="'${ui.message("edtriageapp.trauma")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.trauma.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.trauma.value])"></tr>

							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'digestive'" concept="edTriagePatientConcept.symptoms.digestive"
								selected-concept="edTriagePatient.symptoms.digestive.value" concept-label="'${ui.message("edtriageapp.digestive")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.digestive.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.digestive.value])"></tr>

								<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'pregnancy'" ng-if="edTriagePatient.patient.gender == 'F'"
								concept="edTriagePatientConcept.symptoms.pregnancy"
								selected-concept="edTriagePatient.symptoms.pregnancy.value" concept-label="'${ui.message("edtriageapp.pregnancy")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.pregnancy.value])"
									score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex=="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.pregnancy.value])"></tr>

							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'respiratory'" concept="edTriagePatientConcept.symptoms.respiratory"
								selected-concept="edTriagePatient.symptoms.respiratory.value" concept-label="'${ui.message("edtriageapp.respiratory")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.respiratory.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex=="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.respiratory.value])"></tr>

							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'pain'" concept="edTriagePatientConcept.symptoms.pain"
								selected-concept="edTriagePatient.symptoms.pain.value" concept-label="'${ui.message("edtriageapp.pain")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.pain.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex=="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.pain.value])"></tr>

							<tr concept-selector-row ed-triage-patient="edTriagePatient" input-id="'other'" concept="edTriagePatientConcept.symptoms.other"
								selected-concept="edTriagePatient.symptoms.other.value" concept-label="'${ui.message("edtriageapp.other")}'"
								score-label-class="'edtriage-label-' + getColorClass(currentScore.individualScores[edTriagePatient.symptoms.other.value])"
								score="'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'" scorex=="getColorClass(currentScore.individualScores[edTriagePatient.symptoms.other.value])"></tr>

						</tbody>
					</table>
                </div>
            </div>
        </div>
    </div>
    </form>
	<div class="alert alert-{{message.type}} alert-dismissible fade in" role="alert" ng-show="message.text.length > 0">
		<button type="button" class="close" data-dismiss="alert" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		{{message.text}}
	</div>

    <div class="form-group">
        <div class="col-sm-offset-3 col-sm-3">
            <button type="button" class="btn btn-primary" ng-disabled="isSaving" ng-click="save()">${ ui.message("edtriageapp.submitButton") }</button>
        </div>
        <div class="col-sm-3" ng-if="edTriagePatient.encounterUuid">
			<button type="button" class="btn btn-default" ng-disabled="isSaving" ng-click="beginConsult()">${ ui.message("edtriageapp.beginConsult") }</button>
        </div>
        <div class="col-sm-3">
			<button type="button" class="btn btn-default" ng-disabled="isSaving" ng-click="goToFindPatient()">${ ui.message("edtriageapp.exitButton") }</button>
        </div>
    </div>


	<div ng-if="debug">
		<br/><br/><br/>
		<div class="panel panel-info">
			<div class="panel-heading">
				<h3 class="panel-title">Debug Info</h3>
			</div>
			<div class="panel-body">
				<div class="col-sm-11">
					<div>
						<h2>Current Scores</h2>
						<pre>{{currentScore.individualScores | json}}</pre>
					</div>
					<div>
						<h2>Patient</h2>
						<pre>{{edTriagePatient | json}}</pre>
					</div>
					<div>
						<h2>Concept</h2>
						<pre>{{edTriagePatientConcept | json}}</pre>
					</div>
				</div>
			</div>
		</div>
	</div>


</div>



<script type="text/javascript">
	angular.module('edTriageApp')
			.value('patientUuid', '${ patient.uuid }')
			.value('patientBirthDate', '${ patient.birthdate }')
			.value('patientGender', '${ patient.gender }')
			.value('locationUuid', '${ location.uuid }')

	;
	//angular.bootstrap('#edTriageApp', [ "edTriageApp" ])   ;

	jq(function() {
		// make sure we reload the page if the location is changes; this custom event is emitted by by the location selector in the header
		jq(document).on('sessionLocationChanged', function() {
			window.location.reload();
		});
	});

</script>
