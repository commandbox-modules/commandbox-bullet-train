component {
	property name='print' inject='print';

	function configure() {
		variables.start = getTickCount();
		variables.lastExecutionTime = 0;
	}

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.execTimeEnable || variables.lastExecutionTime < interceptData.settings.execTimeThresholdMS ) { return; }
		
		interceptData.cars.execTime.text = print.text( ' ' & variables.lastExecutionTime & 'ms ', '#interceptData.settings.execTimeText#on#interceptData.settings.execTimeBG#' );
		interceptData.cars.execTime.background = interceptData.settings.execTimeBG;
	}

	function preProcessLine( interceptData ) {
		variables.start = getTickCount();
	}

	function postProcessLine( interceptData ) {
		variables.lastExecutionTime = getTickCount() - variables.start;
	}

}