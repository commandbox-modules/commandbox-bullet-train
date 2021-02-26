component {
	property name='serverService' inject='serverService';
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';
	property name='semanticVersion'		inject='provider:semanticVersion@semver';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.serverEnable ) { return; }
		
		var rootPath = fileSystem.resolvePath( '' );
		var traversePath = '';
		var carSettings = {};
		var serverDetails = {};
		
		try {

			serverDetails = serverService.resolveServerDetails( directory = rootPath, serverProps={} );

			if( !serverDetails.serverIsNew ) {

				carSettings = generateCar(serverDetails, interceptData);	
				interceptData.cars.server.text = carSettings.text;
				interceptData.cars.server.background = carSettings.background;
				
			}else{
				for(var i = 1; i <= interceptData.settings.serverDepth; i++){
					serverDetails = serverService.resolveServerDetails( serverProps={directory=rootPath} );
					if( !serverDetails.serverIsNew ) {
						carSettings = generateCar(serverDetails, interceptData);	
						interceptData.cars.server.text = carSettings.text;
						interceptData.cars.server.background = carSettings.background;

						break;
					}
					traversePath = traversePath & '../';
					rootPath = fileSystem.resolvePath( traversePath );
				}
			}

		} catch( any var e ) {
			interceptData.cars.server.text = print.text( ' Error Fetching Server... ', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' );
			interceptData.cars.server.background = interceptData.settings.serverBG;
		}
		
		
	}
	
	private function generateCar(serverDetails, interceptData){

		var carSettings = {};
		
		// Map the server statuses to a color
		var statusColors = {
			running : 'greenOnWhite',
			starting : 'yellowOnWhite',
			stopped : 'redOnWhite'
		};

		var serverInfo = serverDetails.serverInfo;
		var status = serverService.isServerRunning( serverInfo ) ? 'running' : 'stopped';
		
		if( serverInfo.WARPath.len() ) {
			carSettings.text = print.text( ' ' & serverInfo.WARPath.listLast( '/\' ) & ' '& '(', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' ) 
				& print.text( status, statusColors[ status ] & 'on#interceptData.settings.serverBG#' ) 
				& print.text( ') ', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' );
		} else {
			var version = semanticVersion.parseVersion( serverInfo.engineVersion );
			carSettings.text = print.text( ' ' & serverInfo.engineName & ' ' & version.major & '.' & version.minor & '.' & version.revision & ' '& '(', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' ) 
				& print.text( status, statusColors[ status ] & 'on#interceptData.settings.serverBG#' ) 
				& print.text( ') ', '#interceptData.settings.serverText#on#interceptData.settings.serverBG#' );	
		}
		
		
		carSettings.background = interceptData.settings.serverBG;	
		
		return carSettings;
		
	}

}
