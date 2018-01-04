component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='shell' inject='shell';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.statusEnable ) { return; }
		
		var exitCode = shell.getExitCode();
		if( exitCode == 0 ) {
			interceptData.cars.status.text = print.text( ' #( interceptData.settings.unicode ? '•' : '*' )# ', '#interceptData.settings.statusText#on#interceptData.settings.statusSuccessBG#' );
			interceptData.cars.status.background = interceptData.settings.statusSuccessBG;	
		} else {
			interceptData.cars.status.text = print.text( ' #( interceptData.settings.unicode ? '✘' : 'X' )# ', '#interceptData.settings.statusText#on#interceptData.settings.statusFailBG#' );
			interceptData.cars.status.background = interceptData.settings.statusFailBG;			
		}
		
		
	}

}