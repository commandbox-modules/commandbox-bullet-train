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
		if( day > 0 ) outputTime.append( '#day#d' );
		if( hr > 0 ) outputTime.append( '#hr#hr' );
		if( min > 0 ) outputTime.append( '#min#min' );
		// Ignore seconds and ms for times over an hour to keep things tidy
		if( sec > 0 && hr == 0 && day == 0 ) outputTime.append( '#sec#sec' );
		if( ms > 0 && hr == 0 && day == 0 ) outputTime.append( '#ms#ms' );
		 
		return outputTime.toList( ' ' );
	}

}