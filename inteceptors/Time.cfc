component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.timeEnable ) { return; }
	
		interceptData.cars.time.text = print.text( ' ' & timeFormat( now() ) & ' ', '#interceptData.settings.timeText#on#interceptData.settings.timeBG#' );
		interceptData.cars.time.background = interceptData.settings.timeBG;
	}

}