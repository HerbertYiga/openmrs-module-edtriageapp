package org.openmrs.module.edtriageapp.page.controller;


import org.openmrs.Encounter;
import org.openmrs.Patient;
import org.openmrs.module.appframework.domain.AppDescriptor;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.Redirect;
import org.springframework.web.bind.annotation.RequestParam;

public class EdtriageEditPatientPageController {
    public Object controller(@RequestParam("patientId") Patient patient, PageModel model,
                             @RequestParam(value = "encounterId", required =  false) Encounter encounter,
                             @RequestParam(value = "appId", required = false) AppDescriptor app,
                             @RequestParam(value = "search", required = false) String search,
                             @RequestParam(value = "breadcrumbOverride", required = false) String breadcrumbOverride,
                             UiSessionContext uiSessionContext) {

        if (patient.isVoided() || patient.isPersonVoided()) {
            return new Redirect("coreapps", "patientdashboard/deletedPatient", "patientId=" + patient.getId());
        }

        model.addAttribute("appId", app !=null ? app.getId() : null);
        model.addAttribute("search", search);
        model.addAttribute("breadcrumbOverride", breadcrumbOverride);
        model.addAttribute("locale", uiSessionContext.getLocale());
        model.addAttribute("location", uiSessionContext.getSessionLocation());
        model.addAttribute("patient", patient);
        model.addAttribute("encounter", encounter);
        return null;

    }
}
