component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var calculator = new presidedataobjects.library.RelationshipCalculator();

		describe( "calculateRelationships()", function(){

			it( "should return an empty structure when passed an empty structure of objects", function(){
				expect( calculator.calculateRelationships( objects={} ) ).toBe( {} );
			} );

		} );
	}

}