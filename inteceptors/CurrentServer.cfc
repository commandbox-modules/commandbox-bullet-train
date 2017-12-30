component {
	property name='serverService' inject='serverService';
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';
	property name='semanticVersion'		inject='provider:semanticVersion@semver';

	function onBulletTrain( interceptData ) {
		
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
			var version = semanticVersion.parseVersion( serverInfo.engineVersion );
			
			interceptData.currentServer = print.blackOnWhite( ' ' & serverInfo.engineName & ' ' & version.major & '.' & version.minor & '.' & version.revision & ' '& '('  ) & print.bold( status, statusColors[ status ] ) & print.blackOnWhite( ') >' );	
			
		}
		
		
		
	}

}