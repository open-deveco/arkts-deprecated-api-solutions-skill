# SideBarContainer API 变化指南

## 常见错误

### 1. SideBarContainer 参数类型错误

```
Argument of type 'boolean' is not assignable to parameter of type 'SideBarContainerType'
```

### 2. SideBar 组件不存在

```
Cannot find name 'SideBar'
```

### 3. SwiperItem 组件不存在

```
Cannot find name 'SwiperItem'
```

## 解决方案

### SideBarContainer 替代方案

由于 SideBarContainer API 变化，建议使用条件布局替代：

```typescript
build() {
  Column() {
    if (this.currentBreakpoint === 'lg' || this.currentBreakpoint === 'xl') {
      Row() {
        Column() {
          Text('侧边栏')
            .fontSize(20)
            .padding(20)
        }
        .width(200)
        .height('100%')
        .backgroundColor('#F5F5F5')

        Column() {
          Text('主内容区域')
            .fontSize(24)
        }
        .layoutWeight(1)
        .height('100%')
      }
    } else {
      Column() {
        Text('主内容区域')
          .fontSize(24)
      }
      .width('100%')
      .height('100%')
    }
  }
}
```

### Swiper 使用替代方案

SwiperItem 已弃用，直接使用 Swiper 的子组件：

```typescript
Swiper() {
  ForEach(this.bannerItems, (item: string) => {
    Text(item)  // 直接使用 Text 替代 SwiperItem
      .fontSize(24)
      .width('100%')
      .height(200)
      .backgroundColor('#F0F0F0')
      .textAlign(TextAlign.Center)
  })
}
```

## 详细代码示例

请参考 [SideBarContainerAPIDemo.ets](../assets/SideBarContainerAPIDemo.ets)

## 相关 API

- [SideBarContainer](https://developer.harmonyos.com/cn/docs/documentation/doc-references/arkts-basic-components-sidebarcontainer-0000001773949442)
- [Swiper](https://developer.harmonyos.com/cn/docs/documentation/doc-references/arkts-basic-components-swiper-0000001773949442)
