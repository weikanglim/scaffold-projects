export interface DatabaseConfig {
    connectionString: string
    databaseName: string
}

export interface AppConfig {
    database: DatabaseConfig
}
