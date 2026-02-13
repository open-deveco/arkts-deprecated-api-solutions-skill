import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct NetworkMigration {
  @State responseData: string = '';

  async fetchData() {
    // Modern usage: Remote Communication Kit (rcp)
    const session = rcp.createSession();
    const request = new rcp.Request('https://www.example.com');
    
    try {
      const response = await session.fetch(request);
      if (response.statusCode === 200) {
        this.responseData = response.toString() || 'Success';
      } else {
        this.responseData = `Error: ${response.statusCode}`;
      }
    } catch (e) {
      let err = e as BusinessError;
      this.responseData = `Exception: ${err.message}`;
    } finally {
      session.close();
    }
  }

  build() {
    Column() {
      Button('Fetch Data (RCP)')
        .onClick(() => this.fetchData())
      Text(this.responseData)
        .margin(10)
    }
  }
}
