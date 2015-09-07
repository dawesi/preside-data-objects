component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
	}

	// executes after all suites+specs in the run() method
	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe( "syncSchema", function(){
			it( "should do nothing when the version in the database has not changed", function(){
				var syncService = _getSyncService();
				var mockLibrary = getMockBox().createEmptyMock( "presidedataobjects.library.ObjectLibrary" );

				mockVersioningService.$( "hasDbVersionChanged" ).$args( objectLibrary=mockLibrary ).$results( false );
				mockSqlRunner.$( "runSql" );

				syncService.syncSchema( objectLibrary=mockLibrary );

				expect( mockSqlRunner.$callLog().runSql.len() ).toBe( 0 );
			} );
		} );
	}

/*********************************** PRIVATE HELPERS ***********************************/
	private function _getSyncService() {
		variables.mockdsn               = "testdsn";
		variables.mockVersioningService = getMockBox().createEmptyMock( "presidedataobjects.db.schema.SchemaVersioningService" );
		variables.mockDbInfoService     = getMockBox().createEmptyMock( "presidedataobjects.db.DbInfoService" );
		variables.mockSqlAdapter        = getMockBox().createStub();
		variables.mockAdapterFactory    = getMockBox().createEmptyMock( "presidedataobjects.db.adapter.AdapterFactory" );
		variables.mockSqlRunner         = getMockBox().createEmptyMock( "presidedataobjects.db.SqlRunner" );
		variables.mockSchemaGenerator   = getMockBox().createStub();
		variables.mockTableFieldsHelper = getMockBox().createEmptyMock( "presidedataobjects.db.helpers.ObjectTableFieldsHelper" );
		variables.mockAdapterFactory.$( "getAdapter" ).$args( dsn=mockDsn ).$results( mockSqlAdapter );



		return getMockBox().createMock(
			object = new presidedataobjects.db.schema.SchemaSyncService(
				  dsn                     = mockdsn
				, dbInfoService           = mockDbInfoService
				, adapterFactory          = mockAdapterFactory
				, sqlRunner               = mockSqlRunner
				, schemaGenerator         = mockSchemaGenerator
				, schemaVersioningService = mockVersioningService
				, objectTableFieldsHelper = mockTableFieldsHelper
			)
		);
	}
}
