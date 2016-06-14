angular.module("edTriagePatientFactory", [])
    .factory('EdTriagePatient', ['$filter', 'EdTriageConcept', function ($filter, EdTriageConcept) {

        /**
         * Constructor, with class name
         */
        function EdTriagePatient() {
            this.encounterUuid = null;
            this.triageQueueStatus = EdTriageConcept.status.waitingForEvaluation;
            this.encounterDateTime = null;
            this.score = {colorCode: EdTriageConcept.score.green, numericScore:0};
            this.percentComplete = 0;
            this.originalObservationUuids = [];
            this.patient = {uuid:null, age:null, birthdate:null, gender:null, ageType:null, display:null};
            this.location = null;
            this.chiefComplaint = null;
            this.vitals = {
                mobility: null,
                respiratoryRate: null,
                oxygenSaturation: null,
                heartRate: null,
                diastolicBloodPressure: null,
                systolicBloodPressure: null,
                temperature: null,
                consciousness: null,
                trauma: null,
                weight: null
            };
            this.symptoms = {
                neurological: null,
                burn: null,
                trauma: null,
                digestive: null,
                pregnancy: null,
                respiratory: null,
                pain: null,
                other: null
            };

        }

        EdTriagePatient.prototype.vitalsAsString = function(){
            var ret = "";
            if(this.vitals.respiratoryRate != null){
                ret += "Respiratory Rate: " + this.vitals.respiratoryRate.value;
            }

            return ret;
        };

        EdTriagePatient.prototype.waitTime = function(){
            var date = new Date(this.encounterDateTime);
            var now = new Date();
            var w = (now - date)/1000;
            var hr = Math.floor(w /60 /60);
            var mn = Math.floor((w /60) % 60);
            //var sec = Math.floor(w % 60);
            return hr + ":" + (mn<10?"0"+mn:mn);// + ":" + (sec<10?"0"+sec:sec);
        }

        /* creates a new EdTriagePatient
         *  returns an empty one with the patient and location info filled in
         *  @param {String} uuid - the patient uuid
         *  @param {Object} dateOfBirth - the patient date of birth
         *  @param {String} gender - the patient gender
         *  @param {String} locationUuid - the location uuid
         * @returns {EdTriagePatient} the concepts that make up this app
         * */
        EdTriagePatient.newInstance = function(uuid, dateOfBirth, gender, locationUuid) {
            var ret = new EdTriagePatient();
            var age = 12 ; //TODO: calc the real age
            var ageType = 'A';
            if(age < 3){
               ageType = 'I';
            }
            else if (age < 13){
                ageType = 'C';
            }
            ret.patient.uuid = uuid;
            ret.patient.age = age;
            ret.patient.birthdate=dateOfBirth;
            ret.patient.gender=gender;
            ret.patient.age = age;
            ret.patient.ageType=ageType;
            ret.location = locationUuid;

            return ret;
        };

        EdTriagePatient.buildList = function (concepts, data, locationUuid) {

            var patientDateOfBirth = "";
            var patientGender = "";
            var ret = [];
            for(var i = 0;i<data.length;++i){
                var patientUuid = data[i].patient.uuid;
                ret.push(EdTriagePatient.build(concepts, data[i], patientDateOfBirth, patientGender, locationUuid))
            }
            return ret;
        };
        /**
         * Static method, assigned to class
         * Instance ('this') is not available in static context
         */
        EdTriagePatient.build = function (concepts, data, patientDateOfBirth, patientGender, locationUuid) {

            var ret = EdTriagePatient.newInstance(patientDateOfBirth, patientGender, locationUuid) ;
            ret.patient.uuid = data.patient.uuid;
            ret.patient.display = data.patient.display;
            ret.encounterDateTime = data.encounterDatetime;
            ret.encounterUuid = data.uuid;

            console.log("ret.encounterUuid = " + ret.encounterUuid );

            //iterate through the observations and update the appropriate properties
            for (var i = 0; i < data.obs.length; ++i) {
                var uuid = data.obs[i].concept.uuid;
                var obsUuid = data.obs[i].uuid;
                var v = data.obs[i].value;

                if(obsUuid != null){
                    //we keep these, so that we can clear out a person's observations before make the other
                    // updates
                    ret.originalObservationUuids.push(obsUuid);
                }

                if (uuid == concepts.triageQueueStatus.uuid) {
                    ret.triageQueueStatus = _v(v);
                }
                else if (uuid == concepts.triageColorCode.uuid) {
                    ret.score.colorCode = _v(v.uuid);
                }
                else if (uuid == concepts.triageScore.uuid) {
                    ret.score.numericScore = _v(v);
                }
                else if (uuid == concepts.chiefComplaint.uuid) {
                    ret.chiefComplaint = _v(v);
                }
                else if (uuid == concepts.vitals.respiratoryRate.uuid) {
                    ret.vitals.respiratoryRate = _v(v);
                }
                else if (uuid == concepts.vitals.oxygenSaturation.uuid) {
                    ret.vitals.oxygenSaturation = _v(v);
                }
                else if (uuid == concepts.vitals.heartRate.uuid) {
                    ret.vitals.heartRate = _v(v);
                }
                else if (uuid == concepts.vitals.diastolicBloodPressure.uuid) {
                    ret.vitals.diastolicBloodPressure = _v(v);
                }
                else if (uuid == concepts.vitals.systolicBloodPressure.uuid) {
                    ret.vitals.systolicBloodPressure = _v(v);
                }
                else if (uuid == concepts.vitals.temperature.uuid) {
                    ret.vitals.temperature = _v(v);
                }
                else if (uuid == concepts.vitals.trauma.uuid) {
                    ret.vitals.trauma = _v(v);
                }
                else if (uuid == concepts.vitals.weight.uuid) {
                    ret.vitals.weight = _v(v);
                }
                else if (uuid == concepts.vitals.mobility.uuid) {
                    ret.vitals.mobility = _v(v.uuid);
                }
                else {
                    // var lookups = [{o: 'vitals', c: 'mobility', p: 'mobility'},
                    //     {o: 'vitals', c: 'consciousness', p: 'consciousness'},
                    //     {o: 'symptoms', c: 'neurological', p: 'neurological'},
                    //     {o: 'symptoms', c: 'burn', p: 'burn'},
                    //     {o: 'symptoms', c: 'trauma', p: 'trauma'},
                    //     {o: 'symptoms', c: 'digestive', p: 'digestive'},
                    //     {o: 'symptoms', c: 'pregnancy', p: 'pregnancy'},
                    //     {o: 'symptoms', c: 'respiratory', p: 'respiratory'},
                    //     {o: 'symptoms', c: 'pain', p: 'pain'},
                    //     {o: 'symptoms', c: 'other', p: 'other'}];
                    // for (var j = 0; j < lookups.length; ++j) {
                    //     var ok = _updateAnswersFromUuid(concepts, ret, lookups[j], data.obs[i]);
                    //     if (ok) {
                    //         break;
                    //     }
                    // }


                }

            }

            //console.log(ret);

            return ret;
            /*
             * checks if the observation is one of a set of answers
             * @param {Array} answers - the list of answers
             * @param {String} uuid - the uuid of the observation that you are looking up
             * @return {bool} true/false
             * */
            function _updateAnswersFromUuid(concept, edTriagePatientData, lookup, obs) {
                var temp = $filter('filter')(concept[lookup.o][lookup.c].answers, {uuid: obs.uuid});
                if (temp != null && temp.length > 0) {
                    edTriagePatientData[lookup.o][lookup.p] = _v(obs.value, obs.uuid);
                    return true;
                }

                return false;
            }

            /* helper function to make a value object, we need the uuid for saving*/
            function _v(value, uuid){
                return {value:value, uuid:uuid};
            }
        };


        /**
         * Return the constructor function
         */
        return EdTriagePatient;
    }]);