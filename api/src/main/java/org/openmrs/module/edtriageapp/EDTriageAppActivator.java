/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.edtriageapp;


import java.lang.reflect.InvocationTargetException;

import org.apache.commons.logging.Log;

import org.apache.commons.logging.LogFactory;
import org.openmrs.ConceptName;
import org.openmrs.GlobalProperty;
import org.openmrs.api.context.Context;
import org.openmrs.module.BaseModuleActivator;
import org.openmrs.module.DaemonToken;
import org.openmrs.module.DaemonTokenAware;
import org.openmrs.module.ModuleActivator;
import org.openmrs.module.edtriageapp.task.TriageTask;
import org.openmrs.module.dataexchange.DataImporter;


import java.lang.reflect.Method;


/**
 * This class contains the logic that is run every time this module is either started or stopped.
 */
public class EDTriageAppActivator extends BaseModuleActivator implements DaemonTokenAware{
	
	protected Log log = LogFactory.getLog(getClass());
  
	/**
	 * @see ModuleActivator#started()
	 */
	public void started() {
		TriageTask.setEnabled(true);
		//installConcepts();
		log.info("ED Triage App Module started");
	}

	/**
	 * @see ModuleActivator#stopped()
	 */
	public void stopped() {
		log.info("ED Triage App Module stopped");
	}

	@Override
	public void setDaemonToken(DaemonToken daemonToken) {
		TriageTask.setDaemonToken(daemonToken);
	}
}
