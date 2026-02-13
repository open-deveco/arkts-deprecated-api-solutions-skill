import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct LogMigration {
  // Define Domain and Tag
  private readonly DOMAIN: number = 0x0000;
  private readonly TAG: string = 'MyPage';

  build() {
    Column() {
      Button('Log Info')
        .onClick(() => {
          // Modern usage: hilog
          // %{public}s: Privacy-safe string (visible in release logs)
          // %{private}s: Private string (hidden in release logs unless configured)
          hilog.info(this.DOMAIN, this.TAG, 'User clicked button: %{public}s', 'Info');
        })

      Button('Log Error')
        .onClick(() => {
          hilog.error(this.DOMAIN, this.TAG, 'An error occurred: %{public}d', 500);
        })
    }
  }
}
