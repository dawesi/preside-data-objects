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

			it( "should return an empty structure when no relationships exist between the objects", function(){
				var simpleProps = { id={ name="id", type="string" }, label={ name="label", type="string" } };
				var objects     = { object_a=getMockBox().createStub(), object_b=getMockBox().createStub() };

				objects.object_a.$( "listProperties", [ "id", "label" ] );
				objects.object_a.$( "getProperty" ).$args( propertyName="id" ).$results( simpleProps.id );
				objects.object_a.$( "getProperty" ).$args( propertyName="label" ).$results( simpleProps.label );
				objects.object_b.$( "listProperties", [ "id", "label" ] );
				objects.object_b.$( "getProperty" ).$args( propertyName="id" ).$results( simpleProps.id );
				objects.object_b.$( "getProperty" ).$args( propertyName="label" ).$results( simpleProps.label );

				expect( calculator.calculateRelationships( objects=objects ) ).toBe( {} );
			} );

		} );
	}

}