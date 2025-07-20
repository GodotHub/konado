import { defineConfig } from 'vitepress'
import { MermaidMarkdown, MermaidPlugin } from 'vitepress-plugin-mermaid';

export default defineConfig({

  markdown: {
    config(md) {
      md.use(MermaidMarkdown);
    },
  },
  vite: {
    plugins: [MermaidPlugin()],
    optimizeDeps: {
      include: ['mermaid'],
    },
    ssr: {
      noExternal: ['mermaid'],
    },
  },

  title: "Konado",
  base: "/konado/",
  description: "Konado: Visual Novel Framework",
  head: [
    [
      'link',
      { rel: 'icon', href: 'https://godothub.atomgit.net/web/icon/konado_icon.png' }
    ]
  ],
  themeConfig: {
    logo: 'https://godothub.atomgit.net/web/icon/konado_icon.png',
    search: {
      provider: 'local'
    },
    socialLinks: [
      {
        icon: {
          svg: '<svg t="1752549772860" class="icon" viewBox="0 0 1056 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2154" width="200" height="200"><path d="M479.663158 988.429474c-90.004211-10.24-187.553684-48.505263-247.376842-96.471579-33.953684-26.947368-90.004211-88.387368-111.023158-120.724211-64.134737-99.166316-90.004211-222.046316-70.602105-333.608421 18.863158-107.250526 63.056842-191.326316 141.20421-267.856842 135.814737-133.12 353.010526-175.157895 527.090526-101.861053 57.128421 24.252632 112.101053 58.206316 134.736843 82.997895 44.193684 49.044211 28.025263 128.808421-31.258948 158.450526-25.330526 12.395789-72.218947 12.934737-90.543158 1.077895s-35.031579-44.193684-39.343158-77.069473c-2.155789-15.629474-4.850526-28.564211-5.389473-28.564211-1.077895 0-14.551579 7.545263-29.642106 16.168421-49.583158 29.103158-64.134737 33.414737-140.126315 38.265263-39.882105 2.155789-84.075789 5.928421-97.549474 8.084211-24.791579 3.233684-54.972632-1.077895-102.938947-16.168421l-25.330527-8.084211 1.077895 52.277895c0.538947 50.661053 0 53.355789-21.557895 98.088421-28.025263 58.206316-38.265263 93.237895-42.576842 144.976842-10.24 124.496842 57.667368 217.195789 186.47579 253.844211 83.536842 23.713684 221.507368 18.863158 296.421052-10.778948 71.68-28.564211 134.736842-94.854737 134.736842-142.282105 0-19.402105-24.791579-44.193684-51.738947-50.661053-11.317895-3.233684-54.433684-7.006316-95.393684-8.623158-86.770526-3.772632-147.132632-11.856842-163.84-22.635789s-25.330526-40.96-17.785263-63.59579c7.545263-23.713684 19.402105-33.953684 54.433684-46.888421 23.713684-9.162105 40.96-10.778947 109.945263-10.778947 146.593684 0 215.578947 18.324211 269.473684 72.218947 61.978947 62.517895 68.446316 157.372632 16.168421 241.448421-77.069474 123.418947-168.151579 194.021053-291.570526 225.818948-41.498947 11.317895-151.444211 18.324211-196.176842 12.934737z" fill="#D62240" p-id="2155"></path></svg>'
        }, link: 'https://gitcode.com/godothub/konado'
      },
      {
        icon: 'github', link: 'https://github.com/godothub/konado'
      },
      {
        icon: {
          svg: '<?xml version="1.0" encoding="UTF-8" standalone="no"?> <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"> <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="192px" height="192px" viewBox="0 0 192 192" enable-background="new 0 0 192 192" xml:space="preserve">  <image id="image0" width="192" height="192" x="0" y="0" xlink:href="data:image/png;base64,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 MAlr4PwAAAAASUVORK5CYII=" /> </svg>'
        }, link: 'https://atomgit.com/godothub/konado'
      },
      {
        icon:
        {
          svg: '<svg t="1752549910319" class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4388" width="200" height="200"><path d="M512 512m-512 0a512 512 0 1 0 1024 0 512 512 0 1 0-1024 0Z" fill="#FFAD16" p-id="4389"></path><path d="M500.053333 571.733333s-8.533333-25.6-8.533333-35.84v-5.12c0-58.026667 46.08-105.813333 100.693333-105.813333 27.306667 0 52.906667 5.12 71.68 25.6 13.653333-15.36 32.426667-22.186667 52.906667-23.893333-5.12-81.92-69.973333-153.6-150.186667-153.6-40.96 0-80.213333 17.066667-107.52 47.786666C431.786667 290.133333 392.533333 273.066667 351.573333 273.066667c-83.626667 0-150.186667 69.973333-150.186666 155.306666v8.533334c0 15.36 3.413333 32.426667 10.24 49.493333v1.706667c46.08 109.226667 221.866667 237.226667 230.4 242.346666 5.12 3.413333 10.24 5.12 15.36 5.12 5.12 0 11.946667-1.706667 15.36-5.12 3.413333-3.413333 39.253333-27.306667 88.746666-69.973333-27.306667-25.6-49.493333-58.026667-61.44-88.746667z m0 0" fill="#FFFFFF" p-id="4390"></path><path d="M815.786667 539.306667c0-49.493333-39.253333-88.746667-85.333334-88.746667-23.893333 0-46.08 10.24-61.44 27.306667-15.36-17.066667-37.546667-27.306667-61.44-27.306667-47.786667 0-85.333333 40.96-85.333333 88.746667v6.826666c0 8.533333 1.706667 18.773333 6.826667 29.013334v1.706666c25.6 63.146667 128 134.826667 131.413333 138.24 3.413333 1.706667 5.12 3.413333 8.533333 3.413334s6.826667-1.706667 8.533334-3.413334c3.413333-3.413333 90.453333-64.853333 124.586666-122.88 1.706667-1.706667 1.706667-3.413333 3.413334-5.12v-1.706666c1.706667-3.413333 3.413333-8.533333 5.12-11.946667 3.413333-8.533333 5.12-17.066667 5.12-25.6V546.133333v-6.826666z m0 0" fill="#FFFFFF" p-id="4391"></path></svg>'
        }, link: 'https://afdian.tv/item/52230b2860a011f083ef52540025c377'
      },
      {
        icon: {
          svg: '<svg t="1752550100623" class="icon" viewBox="0 0 1110 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="17972" width="200" height="200"><path d="M572.377762 54.631569l409.570556 368.207469v580.792847H109.025692v-580.792847z" fill="#E8E8E8" p-id="17973"></path><path d="M567.586102 0L338.616951 191.063276V69.296232H165.889254v265.93474L0 490.012503l112.967296 121.776541 449.63719-400.756562 435.917561 390.983286 112.017512-112.003265z" fill="#EB7A7A" p-id="17974"></path><path d="M41.847478 942.556032h1004.828612v81.439219H41.847478z" fill="#D9D9D9" p-id="17975"></path><path d="M576.936724 395.584989h-3.936854s-354.616061 3.765893 0 508.371826h3.936854c354.625559-504.605932 0-508.371826 0-508.371826z m-3.457213 182.391749c-33.028735 0-59.803142-26.774408-59.803142-59.803143s26.774408-59.803142 59.803142-59.803142c33.023986 0 59.798394 26.774408 59.798394 59.803142-0.004749 33.028735-26.774408 59.803142-59.798394 59.803143z" fill="#00CCC6" p-id="17976"></path></svg>'
        },
        link: 'https://godothub.com',
        ariaLabel: 'Godot Hub'
      }
    ],
    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2025 DSOE1024, Kamiki_</br>Copyright © 2025 Starry Team'
    }
  },

  locales: {

    root: {
      label: '简体中文',
      lang: 'zh-CN',
      description: 'Konado: 视觉小说框架',
      themeConfig: {
        outlineTitle: '本页目录',
        returnToTopLabel: '返回顶部',
        darkModeSwitchLabel: '深色模式',
        docFooter: {
          prev: '上一页',
          next: '下一页'
        },
        search: {
          provider: 'local',
          options: {
            translations: {
              button: {
                buttonText: '搜索',
                buttonAriaLabel: '搜索'
              },
              modal: {
                footer: {
                  selectText: '选择',
                  navigateText: '切换',
                  closeText: '关闭'
                }
              }
            }
          }
        },
        nav: [
          {
            text: '查看文档', link: '/quickstart'
          },
          {
            text: '更新日志', link: '/update'
          },
          {
            text: '赞助我们', link: 'https://afdian.tv/item/52230b2860a011f083ef52540025c377'
          }
        ],
        sidebar: [
          {
            text: '快速开始',
            link: '/quickstart'
          },
          {
            text: '基础教程',
            items: [
              { text: '对话配置文件', link: '/tutorial/profiles' },
              { text: '演员坐标与缩放', link: '/tutorial/actor-coordinate-and-scaling' },
              { text: '自定义对话框', link: '/tutorial/customize-the-dialogbox' }
            ],
            link: '/tutorial'
          },
          {
            text: 'Konado Script',
            items: [
              { text: '脚本介绍', link: '/script/konado-script' },
              { text: '元数据', link: '/script/meta-data' },
              { text: '普通对话', link: '/script/conversation' },
              {
                text: '背景',
                collapsed: true,
                items: [
                  { text: '背景切换', link: '/script/background-switch' }
                ]
              },
              {
                text: '演员',
                collapsed: true,
                items: [
                  { text: '创建演员', link: '/script/create-actor' },
                  { text: '演员退场', link: '/script/actor-leave' },
                  { text: '演员移动', link: '/script/actor-move' }
                ]
              },
              {
                text: '交互',
                collapsed: true,
                items: [
                  { text: '标签', link: '/script/label' },
                  { text: '选项跳转', link: '/script/option-to-jump' },
                ]
              },
              {
                text: '音频',
                collapsed: true,
                items: [
                  { text: '播放背景音乐', link: '/script/' },
                  { text: '停止背景音乐', link: '/script/' },
                  { text: '播放音效', link: '/script/' }
                ]
              },
              {
                text: '结束',
                collapsed: true,
                items: [
                  { text: '结束对话', link: '/script/' }
                ]
              }
            ]
            , link: 'script'
          },
          {
            text: '开发',
            collapsed: true,
            items: [
              { text: '贡献代码', link: '/develop/' },
              { text: '贡献文档', link: '/develop/' },
              { text: '问题反馈', link: '/develop/' }
            ],
            link: '/develop'
          },
          {
            text: '关于',
            collapsed: true,
            items: [
              { text: '关于Konado', link: '/about/' },
              { text: '看板娘Kona', link: '/about/' },
              { text: '许可证', link: '/about/' },
              { text: '鸣谢', link: '/about/' }
            ],
            link: '/about'
          }
        ]
      }
    },

    tc: {
      label: '繁体中文',
      lang: 'zh-TW',
      themeConfig: {
        nav: [
          { text: 'Home', link: '/' },
        ],
        sidebar: [
          { text: 'Guide', link: '/' }
        ]
      }
    },

    en: {
      label: 'English',
      lang: 'en',
      themeConfig: {
        nav: [
          { text: 'Home', link: '/' },
        ],
        sidebar: [
          { text: 'Guide', link: '/' }
        ]
      }
    }
  }
})
