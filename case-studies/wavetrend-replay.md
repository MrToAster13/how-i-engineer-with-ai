# WaveTrend Replay: a backtesting engine, extracted honestly

A terminal tool that replays candle history bar by bar and paper-trades a strategy against a reconstructed Market Cipher B / WaveTrend oscillator. Its replay engine runs on Node built-ins alone. I wrote it, and this is the honest story of where it came from.

Code: [`MrToAster13/wavetrend-replay`](https://github.com/MrToAster13/wavetrend-replay)

## The honest origin

I did not build a trading bot. I forked a popular one, a YouTuber's Claude + TradingView + BitGet scalper, to understand and improve it. What I did there matters more than the fork:

- **Modularized it.** The bot was a single-file `bot.js` monolith. I split it into focused modules (config, HTTP, market data, indicators, strategy, exchange) with clean seams.
- **Hardened the data layer.** I wrote a fetch wrapper with bounded timeouts, opt-in retries, and a `recoverable` flag that tells a network outage apart from a real bug. Along the way I fixed concrete bugs: an `RSI(3)==0` skip, a missing fetch timeout, an unencoded symbol.
- **Added the only tests.** Upstream had none.
- **Built a replay/backtest engine from scratch.** It is roughly 1,300 lines that don't exist upstream.

That last piece is entirely mine, so I pulled it into its own clean repo. That's this. The fork itself is private, so the claims about it are mine to walk you through rather than yours to click.

## What the engine does

It replays a window of real candles one bar at a time and runs a strategy against a paper portfolio. Think of TradingView's Bar Replay, but scriptable. The signals come from a WaveTrend / Market Cipher B reconstruction built from the public formulas, not a library. It also has a live paper mode that receives real TradingView alerts on its own webhook server, and a manual mode to trade by hand.

- **`src/engine.js`** is a high-water-mark bar processor. You can step back through the chart without double-counting trades. Warm-up nulls are handled, and state resets cleanly on a mode switch.
- **`src/cipher.js` / `src/series.js`** hold the WaveTrend reconstruction over a small pure-function indicator layer (EMA, SMA, Wilder-smoothed RSI). Every function is causal, so revealing bars one at a time never leaks the future.
- **`src/http.js`** is the timeout, retry and `recoverable` wrapper. Retries are off unless a caller asks, and the only caller that asks is the read-only candle fetch.

## Why it's a clean repo

The trading bot is a fork carrying someone else's live-order code and affiliate links. Rather than point a recruiter at that, I extracted only the parts I wrote from scratch. Every engine file traces to my own commits. The four modules that still held the upstream's refactored logic were dropped. They provided about 40 lines of trivial BitGet API glue (a candle-row mapper, a granularity table, a response-envelope check), and I reimplemented those so the engine depends on nothing but Node built-ins. Before pulling it out I confirmed no upstream module ships and that the engine still runs against real market data.

## The backtest folder

The repo also holds `backtest/`, my Market Cipher backtest scripts, moved in from branches of my public `tradingview-mcp` fork. Each copied file names its source branch and commit. These scripts read plot values from a live TradingView Desktop chart over the Chrome DevTools Protocol. So unlike the engine, they need the `chrome-remote-interface` package installed separately, and one of them loads helpers from a `tradingview-mcp` checkout. Its README says so.

## What it demonstrates

- **Refactoring a monolith** into deep, single-purpose modules.
- **Async and API reliability.** The timeout, retry and error thinking keeps a long-running fetcher trustworthy.
- **Indicator math from formulas.** Wilder-smoothed RSI and a WaveTrend reconstruction, not a library call.
- **State-machine design.** A replay cursor you can rewind without corrupting the trade log.
- **Zero-dependency discipline.** The engine uses Node built-ins only and is tested in CI on Node 18, 20, and 22.

## What I'd tell an interviewer

The fork is the first thing I'd say, not the last. My work is the refactor, the hardening, and the replay engine, and I can walk through any of it. The honest limits: the reconstruction approximates the paid Market Cipher indicator from public WaveTrend formulas, and this is a backtesting tool, not a validated trading system. The money-moving path in the original bot has no tests, which is exactly why I don't present it as mine.
