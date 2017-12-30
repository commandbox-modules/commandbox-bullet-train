component {
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		var CWD = fileSystem.resolvePath( '' );
		var repoPath = CWD & '/.git';
		
		
		try {
	
			if( directoryExists( repoPath ) ) {
				
				var GitAPI = createObject( 'java', 'org.eclipse.jgit.api.Git' );
				var git = GitAPI.open( createObject( 'java', 'java.io.File' ).init( repoPath ) );
				var branchName = git.getRepository().getBranch();
				interceptData.Git = print.boldwhiteOnGreen( ' ' & branchName & ' >' );
					
			}
			
		} catch( any var e ) {
			interceptData.Git = 'Git car: ' & e.message;
		}
		
	}

}