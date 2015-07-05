component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		var scanner = new presidedataobjects.library.MultipleDirectoryObjectScanner();

		describe( "scanDirectories()", function(){
			it( "should return an empty struct when given no directories", function(){
				expect( scanner.scanDirectories( directories=[] ) ).toBe( {} );
			} );

			it( "should return a struct with object names as keys and an array of mapped paths per file for values", function(){
				var dirs           = [ "/resources/directoryscanner/testdir1", "/resources/directoryscanner/testdir2", "/resources/directoryscanner/testdir3" ];
				var expectedResult = {
					  object_a = [ "/resources/directoryscanner/testdir1/object_a.cfc", "/resources/directoryscanner/testdir2/object_a.cfc", "/resources/directoryscanner/testdir3/object_a.cfc" ]
					, object_b = [ "/resources/directoryscanner/testdir2/object_b.cfc" ]
					, object_c = [ "/resources/directoryscanner/testdir3/object_c.cfc" ]
					, object_d = [ "/resources/directoryscanner/testdir1/object_d.cfc", "/resources/directoryscanner/testdir3/object_d.cfc" ]
				};

				expect( scanner.scanDirectories( directories=dirs ) ).toBe( expectedResult );
			} );

		} );

	}
}