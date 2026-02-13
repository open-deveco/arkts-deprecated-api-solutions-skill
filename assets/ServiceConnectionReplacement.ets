import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';

export function connectToService(context: common.UIAbilityContext) {
  let want: Want = {
    bundleName: 'com.example.app',
    abilityName: 'ServiceExtAbility'
  };

  let connection = context.connectServiceExtensionAbility(want, {
    onConnect: (element, remote) => {
      console.info('Connected');
    },
    onDisconnect: (element) => {
      console.info('Disconnected');
    },
    onFailed: (code) => {
      console.error(`Failed: ${code}`);
    }
  });
  return connection;
}
