component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		variables.versionTableName        = "_preside_generated_entity_versions";
		variables.mockDsn                 = "mockdsn";
		variables.mockDbInfoService       = getMockBox().createEmptyMock( "presidedataobjects.db.DbInfoService" );
		variables.schemaVersioningService = getMockBox().createMock(
			object = new presidedataobjects.db.schema.SchemaVersioningService(
				  dsn              = mockdsn
				, dbInfoService    = mockDbInfoService
				, versionTableName = versionTableName
			)
		);
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "versioningTableExists", function(){
			it( "should return false when the database table for the setup datasource does not exist", function(){
				mockDbInfoService.$( "getTableInfo" ).$args( tableName=versionTableName, dsn=mockDsn ).$results( QueryNew('') );

				expect( schemaVersioningService.versioningTableExists() ).toBe( false );
			} );

			it( "should return true when the database table exists", function(){
				mockDbInfoService.$( "getTableInfo" ).$args( tableName=versionTableName, dsn=mockDsn ).$results( QueryNew('tablename', 'varchar', [[versionTableName]] ) );

				expect( schemaVersioningService.versioningTableExists() ).toBe( true );
			} );
		} );

	}

/*********************************** PRIVATE HELPERS ***********************************/

}
