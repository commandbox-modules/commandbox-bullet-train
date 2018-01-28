component {
	property name='serverService' inject='serverService';
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';
	property name='semanticVersion'		inject='provider:semanticVersion@semver';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.serverEnable ) { return; }
		
		// Map the server statuses to a color
		var statusColors = {
			running : 'greenOnWhite',
			starting : 'yellowOnWhite',
			stopped : 'redOnWhite'
		};
		
		var serverDetails = serverService.resolveServerDetails( directory = fileSystem.resolvePath( '' ), serverProps={} );
		if( !serverDetails.serverIsNew ) {
			var serverInfo = serverDetails.serverInfo;
			var status = serverService.isServerRunning( serverInfo ) ? 'running' : 'stopped';
			
			if( serverInfo.WARPath.len() ) {
				interceptData.cars.server.text = print.text( ' ' & serverInfo.WARPath.listLast( '/\' ) & ' '& '(', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' ) 
					& print.text( status, statusColors[ status ] & 'on#interceptData.settings.serverBG#' ) 
					& print.text( ') ', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' );
			} else {
				var version = semanticVersion.parseVersion( serverInfo.engineVersion );
				interceptData.cars.server.text = print.text( ' ' & serverInfo.engineName & ' ' & version.major & '.' & version.minor & '.' & version.revision & ' '& '(', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' ) 
					& print.text( status, statusColors[ status ] & 'on#interceptData.settings.serverBG#' ) 
					& print.text( ') ', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' );	
			}
			
			
			interceptData.cars.server.background = interceptData.settings.serverBG;	
			
		}
		
		
		
	}

}