# AppStorage watch 方法弃用迁移指南

## 弃用说明

`AppStorage.watch()` 方法在较新的 HarmonyOS 版本中已不再推荐使用。推荐使用 `@StorageLink` 或 `@StorageProp` 装饰器来实现响应式数据绑定，这些装饰器会自动监听数据变化。

## 错误示例

```typescript
AppStorage.watch('windowWidth', () => {
  console.info('Window width changed');
});
```

**错误信息：**
```
Property 'watch' does not exist on type 'typeof AppStorage'.
```

## 解决方案

### 方案1：使用 @StorageLink（推荐）

`@StorageLink` 会建立双向绑定，当 AppStorage 中的值变化时，组件会自动更新；当组件修改值时，AppStorage 也会同步更新。

```typescript
@Entry
@Component
struct MyComponent {
  @StorageLink('windowWidth') windowWidth: number = 0;

  build() {
    Text(`Window width: ${this.windowWidth}vp`)
  }
}
```

### 方案2：使用 @StorageProp

`@StorageProp` 是单向绑定，只监听 AppStorage 中的值变化，组件内部修改不会同步到 AppStorage。

```typescript
@Entry
@Component
struct MyComponent {
  @StorageProp('windowWidth') windowWidth: number = 0;

  build() {
    Text(`Window width: ${this.windowWidth}vp`)
  }
}
```

### 方案3：手动监听（不推荐）

如果确实需要手动监听，可以使用 `AppStorage.setAndProp()` 配合自定义监听器，但这种方式不如使用装饰器简洁。

```typescript
@Entry
@Component
struct MyComponent {
  @State windowWidth: number = 0;
  private listener: ((key: string) => void) | null = null;

  aboutToAppear() {
    this.listener = (key: string) => {
      if (key === 'windowWidth') {
        this.windowWidth = AppStorage.get<number>('windowWidth') || 0;
      }
    };
    // 注意：这种方式不推荐，仅作示例
  }

  aboutToDisappear() {
    this.listener = null;
  }

  build() {
    Text(`Window width: ${this.windowWidth}vp`)
  }
}
```

## 详细说明

使用装饰器的优势：

1. **自动响应式**：数据变化时自动更新 UI
2. **类型安全**：装饰器提供类型检查
3. **代码简洁**：无需手动管理监听器
4. **内存管理**：自动处理监听器的生命周期
5. **性能优化**：系统级别的响应式更新机制

## 装饰器对比

| 装饰器 | 绑定方向 | 使用场景 | 示例 |
|---------|----------|----------|------|
| `@StorageLink` | 双向绑定 | 需要修改共享状态的场景 | 表单输入、设置项 |
| `@StorageProp` | 单向绑定 | 只需要读取共享状态的场景 | 显示用户信息、配置展示 |
| `@StorageLink` + 自定义 setter | 双向绑定 + 额外逻辑 | 需要在数据变化时执行额外逻辑 | 数据持久化、日志记录 |

## 简单示例

```typescript
@Entry
@Component
struct AppStorageWatchReplacement {
  @StorageLink('windowWidth') windowWidth: number = 0;
  @StorageLink('deviceType') deviceType: string = 'unknown';

  updateDeviceInfo() {
    const width = this.getUIContext().getHostContext()
      .getMainWindowSync()
      .getWindowProperties()
      .windowRect.width;
    
    this.windowWidth = width;
    this.deviceType = width >= 840 ? 'Tablet' : 'Phone';
  }

  build() {
    Column() {
      Text('AppStorage 响应式绑定示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin(20)

      Text(`窗口宽度: ${this.windowWidth}vp`)
        .fontSize(16)
        .margin(20)

      Text(`设备类型: ${this.deviceType}`)
        .fontSize(16)
        .margin(20)

      Button('更新设备信息')
        .onClick(() => {
          this.updateDeviceInfo();
        })
        .margin(20)
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}
```

## 详细代码示例

> [AppStorageWatchReplacement.ets](../assets/AppStorageWatchReplacement.ets) - 完整的 AppStorage watch 方法弃用示例和替代方案
