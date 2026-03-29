# Channel Directory

Use this skill to look up Slack channel IDs. When sending messages or reading from a channel, use the channel ID (not the name) in the `message` tool's `target` or `channel` parameter.

## Channels

| Channel | ID |
|---------|-----|
| `#dispatch` | `C0APBP8JJSX` |
| `#research` | `C0APEJD4JSZ` |
| `#quant-signals` | `C0APBNWUTGB` |
| `#portfolio-daily` | `C0APBP5MS4B` |
| `#portfolio-weekly` | `C0AQCD7Q1U0` |
| `#contrarian` | `C0APX22FG9X` |
| `#market-signals` | `C0APJ5GE8Q2` |
| `#agents` | `C0APH5991U2` |
| `#themes` | `C0AP4KWHXQF` |

## Usage

When you need to send a message to `#research`, use the channel ID:

```
message(action: "send", target: "C0APEJD4JSZ", text: "...")
```

When you need to read messages from `#market-signals`:

```
message(action: "read", channel: "C0APJ5GE8Q2")
```

Always refer to channels by `#name` in human-readable text, but use the ID when calling the `message` tool.
