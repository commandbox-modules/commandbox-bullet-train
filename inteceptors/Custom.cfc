component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.customEnable ) { return; }
		
		// Eval the message
		var msg = getInstance( name='CommandDSL', initArguments={ name : 'echo' } )
			.params( interceptData.settings.customContent )
			.run( returnOutput=true, rawParams=true );
			
		interceptData.cars.custom.text = print.text( msg, '#interceptData.settings.customText#on#interceptData.settings.customBG#' );
		interceptData.cars.custom.background = interceptData.settings.customBG;
	}

}