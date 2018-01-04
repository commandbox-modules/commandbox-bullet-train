component {
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.gitEnable ) { return; }
		
		var CWD = fileSystem.resolvePath( '' );
		var repoPath = CWD & '/.git';
		
		
		try {
	
			if( directoryExists( repoPath ) ) {
				
				var GitAPI = createObject( 'java', 'org.eclipse.jgit.api.Git' );
				var git = GitAPI.open( createObject( 'java', 'java.io.File' ).init( repoPath ) );
				var branchName = git.getRepository().getBranch();
				interceptData.cars.git.text = print.text( ' ' & branchName & ' ', '#interceptData.settings.gitText#on#interceptData.settings.gitBG#' );
					
				interceptData.cars.git.background = interceptData.settings.gitBG;
			}
			
		} catch( any var e ) {
			interceptData.Git = 'Git car: ' & e.message;
		}
		
	}

}