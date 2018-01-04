component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.dirEnable ) { return; }
		
		var homeDir = fileSystem.normalizeSlashes( fileSystem.resolvePath( '~' ) );
		var thisFullpath = fileSystem.normalizeSlashes( fileSystem.resolvePath( '' ) );
		var thisPath = thisFullpath.listLast( '\/' ) & '/';
		
		// Shortcut for home dir
		if( thisFullpath contains homeDir ) {
			thisPath = thisFullpath.replaceNoCase( homeDir, '~/' );
		}
		
		interceptData.cars.dir.text = print.text( ' ' & thispath & ' ', '#interceptData.settings.dirText#on#interceptData.settings.dirBG#' );
			
		interceptData.cars.dir.background = interceptData.settings.dirBG;	
	}

}