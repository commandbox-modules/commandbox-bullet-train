component {
	property name='print' inject='print';

	function configure() {
		variables.start = getTickCount();
		variables.lastExecutionTimeMS = 0;
	}

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.execTimeEnable || variables.lastExecutionTimeMS < interceptData.settings.execTimeThresholdMS ) { return; }
		
		interceptData.cars.execTime.text = print.text( ' ' & formatExecTime( variables.lastExecutionTimeMS ) & ' ', '#interceptData.settings.execTimeText#on#interceptData.settings.execTimeBG#' );
		interceptData.cars.execTime.background = interceptData.settings.execTimeBG;
	}

	function preProcessLine( interceptData ) {
		variables.start = getTickCount();
	}

	function postProcessLine( interceptData ) {
		variables.lastExecutionTimeMS = getTickCount() - variables.start;
	}
	
	function formatExecTime( ms ) {
		
		var day = 0;
		var hr = 0;
		var min = 0;
		var sec = 0;
		
		while( ms >= 1000 ) {
			
		  ms = (ms - 1000);
		  sec = sec + 1;
		  if (sec >= 60) min = min + 1;
		  if (sec == 60) sec = 0;
		  if (min >= 60) hr = hr + 1;
		  if (min == 60) min = 0;
		  if (hr >= 24) {
		    hr = (hr - 24);
		    day = day + 1;
		  }
		  
		}
		var outputTime = [];
		// Output days if > 0
		if( day ) outputTime.append( '#day#d' );
		// Output hours if they exist or if we printed days (3d 0hr 13min)
		if( hr || day ) outputTime.append( '#hr#hr' );
		// Output minutes if they exist or if we printed days or hours  (2hr 0min) or (3d 0hr 0min)
		if( min || day || hr ) outputTime.append( '#min#min' );
		// Ignore seconds for times over an hour. (2hr 31min) Print zero seconds if there were minutes (3min 0sec)
		if( ( sec || min ) && !hr && !day ) outputTime.append( '#sec#sec' );
		// Ignore ms for times over a minute. (3min 12sec) (12sec 125ms) (750ms) Omit zero ms (3sec)
		if( ms && !hr && !day && !min ) outputTime.append( '#ms#ms' );
		 
		return outputTime.toList( ' ' );
	}

}