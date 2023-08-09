export interface ApiConfig {
    baseUrl: string
}

export interface AppConfig {
    api: ApiConfig
}

const config: AppConfig = {
    api: {
        baseUrl: window.ENV_CONFIG.REACT_APP_API_BASE_URL || 'http://localhost:3100'
    }
}

export default config;