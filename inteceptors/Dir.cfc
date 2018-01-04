component {
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.dirEnable ) { return; }
		
		interceptData.cars.dir.text = print.text( ' ' & fileSystem.resolvePath( '' ).listLast( '\/' ) & '/ ', '#interceptData.settings.dirText#on#interceptData.settings.dirBG#' );
			
		interceptData.cars.dir.background = interceptData.settings.dirBG;	
	}

}