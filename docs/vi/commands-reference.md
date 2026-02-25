# Tham khảo lệnh openbnc

Dựa trên CLI hiện tại (`openbnc --help`).

Xác minh lần cuối: **2026-02-20**.

## Lệnh cấp cao nhất

| Lệnh | Mục đích |
|---|---|
| `onboard` | Khởi tạo workspace/config nhanh hoặc tương tác |
| `agent` | Chạy chat tương tác hoặc chế độ gửi tin nhắn đơn |
| `gateway` | Khởi động gateway webhook và HTTP WhatsApp |
| `daemon` | Khởi động runtime có giám sát (gateway + channels + heartbeat/scheduler tùy chọn) |
| `service` | Quản lý vòng đời dịch vụ cấp hệ điều hành |
| `doctor` | Chạy chẩn đoán và kiểm tra trạng thái |
| `status` | Hiển thị cấu hình và tóm tắt hệ thống |
| `cron` | Quản lý tác vụ định kỳ |
| `models` | Làm mới danh mục model của provider |
| `providers` | Liệt kê ID provider, bí danh và provider đang dùng |
| `channel` | Quản lý kênh và kiểm tra sức khỏe kênh |
| `integrations` | Kiểm tra chi tiết tích hợp |
| `skills` | Liệt kê/cài đặt/gỡ bỏ skills |
| `migrate` | Nhập dữ liệu từ runtime khác (hiện hỗ trợ OpenClaw) |
| `config` | Xuất schema cấu hình dạng máy đọc được |
| `completions` | Tạo script tự hoàn thành cho shell ra stdout |
| `hardware` | Phát hiện và kiểm tra phần cứng USB |
| `peripheral` | Cấu hình và nạp firmware thiết bị ngoại vi |

## Nhóm lệnh

### `onboard`

- `openbnc onboard`
- `openbnc onboard --interactive`
- `openbnc onboard --channels-only`
- `openbnc onboard --api-key <KEY> --provider <ID> --memory <sqlite|lucid|markdown|none>`
- `openbnc onboard --api-key <KEY> --provider <ID> --model <MODEL_ID> --memory <sqlite|lucid|markdown|none>`

### `agent`

- `openbnc agent`
- `openbnc agent -m "Hello"`
- `openbnc agent --provider <ID> --model <MODEL> --temperature <0.0-2.0>`
- `openbnc agent --peripheral <board:path>`

### `gateway` / `daemon`

- `openbnc gateway [--host <HOST>] [--port <PORT>]`
- `openbnc daemon [--host <HOST>] [--port <PORT>]`

### `service`

- `openbnc service install`
- `openbnc service start`
- `openbnc service stop`
- `openbnc service restart`
- `openbnc service status`
- `openbnc service uninstall`

### `cron`

- `openbnc cron list`
- `openbnc cron add <expr> [--tz <IANA_TZ>] <command>`
- `openbnc cron add-at <rfc3339_timestamp> <command>`
- `openbnc cron add-every <every_ms> <command>`
- `openbnc cron once <delay> <command>`
- `openbnc cron remove <id>`
- `openbnc cron pause <id>`
- `openbnc cron resume <id>`

### `models`

- `openbnc models refresh`
- `openbnc models refresh --provider <ID>`
- `openbnc models refresh --force`

`models refresh` hiện hỗ trợ làm mới danh mục trực tiếp cho các provider: `openrouter`, `openai`, `anthropic`, `groq`, `mistral`, `deepseek`, `xai`, `together-ai`, `gemini`, `ollama`, `astrai`, `venice`, `fireworks`, `cohere`, `moonshot`, `glm`, `zai`, `qwen` và `nvidia`.

### `channel`

- `openbnc channel list`
- `openbnc channel start`
- `openbnc channel doctor`
- `openbnc channel bind-telegram <IDENTITY>`
- `openbnc channel add <type> <json>`
- `openbnc channel remove <name>`

Lệnh trong chat khi runtime đang chạy (Telegram/Discord):

- `/models`
- `/models <provider>`
- `/model`
- `/model <model-id>`

Channel runtime cũng theo dõi `config.toml` và tự động áp dụng thay đổi cho:
- `default_provider`
- `default_model`
- `default_temperature`
- `api_key` / `api_url` (cho provider mặc định)
- `reliability.*` cài đặt retry của provider

`add/remove` hiện chuyển hướng về thiết lập có hướng dẫn / cấu hình thủ công (chưa hỗ trợ đầy đủ mutator khai báo).

### `integrations`

- `openbnc integrations info <name>`

### `skills`

- `openbnc skills list`
- `openbnc skills install <source>`
- `openbnc skills remove <name>`

`<source>` chấp nhận git remote (`https://...`, `http://...`, `ssh://...` và `git@host:owner/repo.git`) hoặc đường dẫn cục bộ.

Skill manifest (`SKILL.toml`) hỗ trợ `prompts` và `[[tools]]`; cả hai được đưa vào system prompt của agent khi chạy, giúp model có thể tuân theo hướng dẫn skill mà không cần đọc thủ công.

### `migrate`

- `openbnc migrate openclaw [--source <path>] [--dry-run]`

### `config`

- `openbnc config schema`

`config schema` xuất JSON Schema (draft 2020-12) cho toàn bộ hợp đồng `config.toml` ra stdout.

### `completions`

- `openbnc completions bash`
- `openbnc completions fish`
- `openbnc completions zsh`
- `openbnc completions powershell`
- `openbnc completions elvish`

`completions` chỉ xuất ra stdout để script có thể được source trực tiếp mà không bị lẫn log/cảnh báo.

### `hardware`

- `openbnc hardware discover`
- `openbnc hardware introspect <path>`
- `openbnc hardware info [--chip <chip_name>]`

### `peripheral`

- `openbnc peripheral list`
- `openbnc peripheral add <board> <path>`
- `openbnc peripheral flash [--port <serial_port>]`
- `openbnc peripheral setup-uno-q [--host <ip_or_host>]`
- `openbnc peripheral flash-nucleo`

## Kiểm tra nhanh

Để xác minh nhanh tài liệu với binary hiện tại:

```bash
openbnc --help
openbnc <command> --help
```
