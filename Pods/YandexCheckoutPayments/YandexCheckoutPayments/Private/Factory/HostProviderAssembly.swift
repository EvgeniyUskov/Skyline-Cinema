import YandexMoneyCoreApi

enum HostProviderAssembly {
    static func makeHostProvider() -> YandexMoneyCoreApi.HostProvider {
        return HostProvider(settingStorage: KeyValueStoringAssembly.makeSettingsStorage())
    }
}
