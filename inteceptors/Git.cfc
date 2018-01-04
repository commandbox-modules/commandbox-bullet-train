component {
	
	processingdirective pageEncoding='UTF-8';
	
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.gitEnable ) { return; }
		
		var CWD = fileSystem.resolvePath( '' );
		var repoPath = CWD & '/.git';
		
		/*
		TODO:
		equals sign for synced
		up arrow for ahead state from remote
		down arrow for behind state from remote
		up/down arrow for diverged state from remote
		*/
		
		try {
	
			if( directoryExists( repoPath ) ) {
				var unicode = interceptData.settings.unicode;
				
				var GitAPI = createObject( 'java', 'org.eclipse.jgit.api.Git' );
				var git = GitAPI.open( createObject( 'java', 'java.io.File' ).init( repoPath ) );
				var branchName = git.getRepository().getBranch();
				
				var repoStatus = git.status().call();
				var isClean = repoStatus.isClean();
				var hasAdded = arrayLen( repoStatus.getAdded() );
				var hasConflicting = arrayLen( repoStatus.getConflicting() );
				var hasChanged = arrayLen( repoStatus.getChanged() );
				var hasMissing = arrayLen( repoStatus.getMissing() );
				var hasModified = arrayLen( repoStatus.getModified() );
				var hasRemoved = arrayLen( repoStatus.getRemoved() );
				var hasUnCommittedChanges = arrayLen( repoStatus.getUncommittedChanges() );
				var hasUntracked = arrayLen( repoStatus.getUntracked() );
				var hasUntrackedFolders = arrayLen( repoStatus.getUntrackedFolders() );
				
				/*systemoutput( 'isClean: ' & isClean, 1 )
				systemoutput( 'hasAdded: ' & hasAdded, 1 )
				systemoutput( 'hasConflicting: ' & hasConflicting, 1 )
				systemoutput( 'hasChanged: ' & hasChanged, 1 )
				systemoutput( 'hasMissing: ' & hasMissing, 1 )
				systemoutput( 'hasRemoved: ' & hasRemoved, 1 )
				systemoutput( 'hasModified: ' & hasModified, 1 )
				systemoutput( 'hasUnCommittedChanges: ' & hasUnCommittedChanges, 1 )
				systemoutput( 'hasUntracked: ' & hasUntracked, 1 )
				systemoutput( 'hasUntrackedFolders: ' & hasUntrackedFolders, 1 )*/
				
				var backgroundColor = isClean ? interceptData.settings.gitCleanBG : interceptData.settings.gitDirtyBG;
				
				// The same file can have a staged modification and also be modified again in the working directory.
				// Get a unique list of modified file names.
				var uniqueModified = {};
				for( var file in repoStatus.getModified().toArray() ) {
					uniqueModified[ file ] = '';
				}
				for( var file in repoStatus.getChanged().toArray() ) {
					uniqueModified[ file ] = '';
				}
				unniqueModifiedCount = uniqueModified.count();
				
				var statusText = '';
				if( unicode ) {
					statusText &= '➽ ';
				}
				statusText &= branchName ;
				
				// file added
				if( hasUntracked || hasAdded ) {
					statusText &= ' +#hasUntracked+hasAdded#';
				}				
				// File modified
				if( unniqueModifiedCount ) {
					statusText &= ' ~#unniqueModifiedCount#';
				}				
				// File deleted
				if( hasMissing || hasRemoved ) {
					statusText &= ' -#hasMissing+hasRemoved#';
				}

				interceptData.cars.git.text = print.text( ' ' & statusText & ' ', '#interceptData.settings.gitText#on#backgroundColor#' );					
				interceptData.cars.git.background = backgroundColor;
			}
			
		} catch( any var e ) {
			interceptData.cars.git.text = 'Git car: ' & e.message;
			interceptData.cars.git.background = 'black';
		} finally {
			
			// Release file system locks on the repo
			if( structKeyExists( local, 'git' ) ) {
				git.getRepository().close();
				git.close();
			}
		}
		
	}

}