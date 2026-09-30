<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<meta name="theme-color" content="#0D0A1A">
<title>情绪温度测试 · 热成像人格扫描</title>
<style>
/* ============================================================
   情绪温度测试 — Thermal Scan
   ============================================================ */
:root{
  --bg0:#07050E;
  --bg1:#0D0A1A;
  --line:rgba(255,255,255,.075);
  --line-2:rgba(255,255,255,.14);
  --t0:#F5F2FB;
  --t1:rgba(245,242,251,.62);
  --t2:rgba(245,242,251,.36);
  --acc:#2BE0C8;
  --acc-lt:#8AF6E8;
  --acc-dk:#0E9E92;
  --acc-ink:#032420;
  --acc-glow:rgba(43,224,200,.75);
  --acc-line:rgba(43,224,200,.5);
  --ink:#180A03;
  --ease:cubic-bezier(.22,1,.36,1);
  /* 结果页 · 温度坐标用的冷→热数据色带 */
  --ramp:linear-gradient(90deg,#3B5BFF 0%,#5AA8FF 18%,#8FE3E0 34%,#FFD166 54%,#FF9A2E 76%,#FF4D2C 100%);
  /* 答题阶段 · 热值注入条(薄荷青绿仪器色) */
  --acc-ramp:linear-gradient(90deg,#0A7F7A 0%,#17C7B4 32%,#2BE0C8 62%,#8AF6E8 100%);
  --sans:-apple-system,BlinkMacSystemFont,"Segoe UI","PingFang SC","Hiragino Sans GB","Microsoft YaHei","Helvetica Neue",Arial,sans-serif;
  --mono:ui-monospace,"SFMono-Regular","SF Mono",Menlo,Consolas,"Liberation Mono",monospace;
}

*{margin:0;padding:0;box-sizing:border-box;-webkit-tap-highlight-color:transparent;}
html,body{height:100%;}
body{
  background:var(--bg0);color:var(--t0);font-family:var(--sans);
  font-size:16px;line-height:1.6;overflow:hidden;
  -webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility;
}
button{font-family:inherit;border:none;background:none;color:inherit;cursor:pointer;}
.mono{font-family:var(--mono);font-variant-numeric:tabular-nums;}

/* ---------- background ---------- */
.app{position:relative;height:100vh;height:100dvh;overflow:hidden;}
.bg{position:absolute;inset:0;z-index:0;overflow:hidden;
  background:radial-gradient(120% 80% at 50% 0%,#1A1230 0%,var(--bg1) 45%,var(--bg0) 100%);}
.blob{position:absolute;border-radius:50%;filter:blur(70px);opacity:.5;will-change:transform,opacity;
  transition:opacity .9s var(--ease);}
.blob-cold{width:70vw;height:70vw;max-width:520px;max-height:520px;top:-22%;left:-28%;
  background:radial-gradient(circle,rgba(59,91,255,.55),rgba(59,91,255,0) 66%);
  animation:drift1 22s ease-in-out infinite;}
.blob-teal{width:78vw;height:78vw;max-width:600px;max-height:600px;bottom:-26%;right:-32%;
  background:radial-gradient(circle,rgba(43,224,200,.34),rgba(43,224,200,0) 66%);
  animation:drift2 26s ease-in-out infinite;}
@keyframes drift1{0%,100%{transform:translate3d(0,0,0) scale(1)}50%{transform:translate3d(6vw,4vh,0) scale(1.12)}}
@keyframes drift2{0%,100%{transform:translate3d(0,0,0) scale(1.06)}50%{transform:translate3d(-7vw,-5vh,0) scale(1)}}
.grid-wrap{position:absolute;inset:0;overflow:hidden;
  -webkit-mask-image:radial-gradient(90% 70% at 50% 45%,#000 0%,transparent 78%);
  mask-image:radial-gradient(90% 70% at 50% 45%,#000 0%,transparent 78%);}
.grid{position:absolute;inset:-50px;opacity:.5;
  background-image:linear-gradient(rgba(255,255,255,.028) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.028) 1px,transparent 1px);
  background-size:46px 46px;
  animation:gridDrift 34s linear infinite;}
@keyframes gridDrift{to{transform:translate3d(46px,-46px,0);}}

/* ---------- 初始页的大气层 ---------- */
.blob-violet{width:84vw;height:84vw;max-width:660px;max-height:660px;top:24%;left:50%;margin-left:-42vw;
  background:radial-gradient(circle,rgba(120,70,215,.42),rgba(120,70,215,0) 66%);
  animation:drift3 32s ease-in-out infinite;}
@keyframes drift3{0%,100%{transform:translate3d(-5vw,3vh,0) scale(1)}50%{transform:translate3d(6vw,-4vh,0) scale(1.13)}}

.bg-intro{position:absolute;inset:0;pointer-events:none;
  opacity:0;visibility:hidden;transition:opacity .85s var(--ease),visibility .85s;}
.bg.intro-on .bg-intro{opacity:1;visibility:visible;}

/* 热成像等高线场：两套独立的等值线互相缓慢错动 */
.contour{position:absolute;inset:0;width:100%;height:100%;transform-origin:50% 38%;
  -webkit-mask-image:radial-gradient(74% 48% at 50% 38%,#000 6%,rgba(0,0,0,.4) 54%,transparent 88%);
  mask-image:radial-gradient(74% 48% at 50% 38%,#000 6%,rgba(0,0,0,.4) 54%,transparent 88%);}
.contour.a{animation:cfA 38s ease-in-out infinite;}
.contour.b{animation:cfB 52s ease-in-out infinite;}
@keyframes cfA{0%,100%{transform:scale(1) rotate(0deg)}50%{transform:scale(1.035) rotate(3.2deg)}}
@keyframes cfB{0%,100%{transform:scale(1.05) rotate(-3.6deg)}50%{transform:scale(1) rotate(2.4deg)}}

/* 缓慢横扫的探测光带 */
.beam{position:absolute;top:-45%;left:0;width:58%;height:190%;
  background:linear-gradient(90deg,transparent,rgba(43,224,200,.05) 38%,
    rgba(232,255,250,.085) 50%,rgba(43,224,200,.05) 62%,transparent);
  filter:blur(11px);transform:rotate(14deg) translateX(-170%);
  animation:beamSweep 17s cubic-bezier(.55,.05,.45,.95) infinite;}
@keyframes beamSweep{
  0%{transform:rotate(14deg) translateX(-170%);opacity:0}
  14%{opacity:1}
  86%{opacity:1}
  100%{transform:rotate(14deg) translateX(430%);opacity:0}}

/* 上升的热粒子（像热成像里往上飘的热羽） */
.dust{position:absolute;inset:0;overflow:hidden;}
.dust i{position:absolute;bottom:-14px;display:block;border-radius:50%;
  background:rgba(232,255,250,.9);box-shadow:0 0 7px rgba(43,224,200,.85);opacity:0;
  animation-name:rise;animation-timing-function:linear;animation-iteration-count:infinite;}
@keyframes rise{
  0%{transform:translate3d(0,0,0) scale(.6);opacity:0}
  10%{opacity:.6}
  62%{opacity:.4}
  100%{transform:translate3d(var(--dx,12px),-94vh,0) scale(1.15);opacity:0}}

/* 左右边缘的温度刻度尺 */
.edge-ruler{position:absolute;top:50%;transform:translateY(-50%);height:56%;
  display:flex;flex-direction:column;justify-content:space-between;
  transition:opacity .7s var(--ease),visibility .7s;}
.edge-ruler.l{left:8px;align-items:flex-start;}
.edge-ruler.r{right:8px;align-items:flex-end;}
.edge-ruler i{display:block;width:6px;height:1px;border-radius:1px;background:rgba(245,242,251,.17);}
.edge-ruler i.hi{width:11px;background:rgba(43,224,200,.45);}
.bg:not(.intro-on) .edge-ruler{opacity:0;visibility:hidden;}

/* 四角框线（常驻） */
.corner{position:absolute;width:20px;height:20px;border:0 solid rgba(43,224,200,.42);
  pointer-events:none;opacity:.55;}
.corner.tl{top:11px;left:11px;border-top-width:1px;border-left-width:1px;border-top-left-radius:7px;}
.corner.tr{top:11px;right:11px;border-top-width:1px;border-right-width:1px;border-top-right-radius:7px;}
.corner.bl{bottom:11px;left:11px;border-bottom-width:1px;border-left-width:1px;border-bottom-left-radius:7px;}
.corner.br{bottom:11px;right:11px;border-bottom-width:1px;border-right-width:1px;border-bottom-right-radius:7px;}
.noise{position:absolute;inset:0;opacity:.05;mix-blend-mode:overlay;pointer-events:none;
  background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='140'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.85' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");}
.scanlines{position:absolute;inset:0;opacity:.22;pointer-events:none;
  background-image:repeating-linear-gradient(to bottom,rgba(255,255,255,.05) 0 1px,transparent 1px 3px);
  -webkit-mask-image:linear-gradient(to bottom,#000,transparent 65%);
  mask-image:linear-gradient(to bottom,#000,transparent 65%);}
.vign{position:absolute;inset:0;pointer-events:none;box-shadow:inset 0 0 140px 40px rgba(0,0,0,.65);}

/* ---------- stage ---------- */
.stage{position:relative;z-index:1;height:100%;}
.screen{position:absolute;inset:0;display:flex;flex-direction:column;
  overflow-y:auto;overflow-x:hidden;-webkit-overflow-scrolling:touch;
  opacity:0;visibility:hidden;transform:translate3d(0,14px,0);
  transition:opacity .48s var(--ease),transform .48s var(--ease),visibility .48s;}
.screen.active{opacity:1;visibility:visible;transform:none;}
.pad{width:100%;max-width:460px;margin:0 auto;
  padding:calc(22px + env(safe-area-inset-top)) 22px calc(34px + env(safe-area-inset-bottom));
  flex:1;display:flex;flex-direction:column;}

/* ---------- atoms ---------- */
.hud{display:flex;align-items:center;justify-content:space-between;
  font-size:10px;letter-spacing:.18em;text-transform:uppercase;color:var(--t2);}
.hud .dot{display:inline-block;width:5px;height:5px;border-radius:50%;background:var(--acc);
  box-shadow:0 0 8px 1px var(--acc-glow);margin-right:7px;vertical-align:middle;
  animation:blip 1.8s ease-in-out infinite;}
@keyframes blip{0%,100%{opacity:1}50%{opacity:.25}}
.hud-l{display:flex;align-items:center;}

/* ---------- intro ---------- */
.intro-orb-wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:20px 0 8px;min-height:190px;}
.orb{position:relative;width:min(58vw,236px);aspect-ratio:1;display:grid;place-items:center;}
.orb::before{content:"";position:absolute;inset:-30%;border-radius:50%;
  background:radial-gradient(circle,rgba(43,224,200,.26),rgba(43,224,200,0) 62%);filter:blur(26px);}
.orb::after{content:"";position:absolute;inset:-14%;border-radius:50%;
  background:radial-gradient(circle,rgba(14,158,146,.26),rgba(14,158,146,0) 60%);filter:blur(30px);}
.orb-sweep{position:absolute;inset:0;border-radius:50%;
  background:conic-gradient(from 0deg,rgba(43,224,200,0) 0deg,rgba(43,224,200,0) 300deg,
    rgba(43,224,200,.04) 324deg,rgba(110,243,224,.11) 344deg,rgba(160,250,238,.26) 356deg,rgba(228,255,249,.62) 360deg);
  -webkit-mask:radial-gradient(circle,transparent 0 27%,#000 32%);
  mask:radial-gradient(circle,transparent 0 27%,#000 32%);
  animation:sweep 4.4s linear infinite;}
@keyframes sweep{to{transform:rotate(360deg)}}
.orb-core{position:absolute;width:34%;aspect-ratio:1;border-radius:50%;
  background:radial-gradient(circle at 50% 46%,#E8FFFA,#7DF5E2 26%,#2BE0C8 56%,rgba(43,224,200,0) 78%);
  filter:blur(9px);animation:corePulse 3.4s ease-in-out infinite;}
@keyframes corePulse{0%,100%{transform:scale(.88);opacity:.7}50%{transform:scale(1.08);opacity:1}}
.orb-svg{position:absolute;inset:0;width:100%;height:100%;overflow:visible;}
.ring-tick{fill:none;stroke:rgba(255,255,255,.135);stroke-width:1;stroke-dasharray:1.6 7.4;}
.ring-thin{fill:none;stroke:rgba(255,255,255,.09);stroke-width:1;}
.ring-acc{fill:none;stroke:rgba(43,224,200,.32);stroke-width:1;stroke-dasharray:34 14;
  transform-box:fill-box;transform-origin:center;animation:spin 26s linear infinite;}
@keyframes spin{to{transform:rotate(360deg)}}
.tick-lg{stroke:rgba(255,255,255,.38);stroke-width:1.5;stroke-linecap:round;}

.intro-txt{text-align:center;padding-bottom:6px;}
.intro-kicker{font-size:10px;letter-spacing:.34em;color:var(--acc);text-transform:uppercase;margin-bottom:14px;opacity:.85;}
.intro-title{font-size:clamp(30px,8.6vw,38px);font-weight:700;letter-spacing:.02em;line-height:1.18;
  background:linear-gradient(112deg,#E8FFFA 0%,#8AF6E8 28%,#2BE0C8 62%,#0E9E92 100%);
  -webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent;}
.intro-sub{margin-top:12px;font-size:10px;letter-spacing:.3em;color:var(--t2);text-transform:uppercase;}
.intro-desc{margin:20px auto 0;max-width:330px;font-size:13.5px;line-height:1.9;color:var(--t1);}
.intro-meta{display:flex;justify-content:center;gap:10px;margin:24px 0 22px;flex-wrap:wrap;}
.chip{display:flex;align-items:center;gap:6px;padding:7px 13px;border-radius:999px;
  border:1px solid var(--line);background:rgba(255,255,255,.025);font-size:11px;color:var(--t1);}
.chip b{font-family:var(--mono);font-weight:500;color:var(--acc);font-size:12px;}

/* ---------- buttons ---------- */
.btn{position:relative;width:100%;height:54px;border-radius:15px;font-size:15px;font-weight:600;
  letter-spacing:.04em;display:flex;align-items:center;justify-content:center;gap:9px;
  transition:transform .16s var(--ease),box-shadow .3s var(--ease);overflow:hidden;}
.btn:active{transform:scale(.972);}
.btn-primary{color:var(--acc-ink);background:linear-gradient(103deg,#8AF6E8 0%,#2BE0C8 46%,#12B3A4 100%);
  box-shadow:0 10px 30px -8px rgba(43,224,200,.5),inset 0 1px 0 rgba(255,255,255,.55);}
/* 结果页 · 主按钮切换成你的专属温度色 */
#s-result .btn-primary{color:#0B0A14;
  background:linear-gradient(103deg,var(--c-t,#FFD166) 0%,var(--c-a,#FF8A3D) 100%);
  box-shadow:0 10px 30px -8px var(--glow-b,#FF9A2E),inset 0 1px 0 rgba(255,255,255,.45);}
.btn-primary::after{content:"";position:absolute;top:0;left:-60%;width:40%;height:100%;
  background:linear-gradient(100deg,transparent,rgba(255,255,255,.55),transparent);
  transform:skewX(-18deg);animation:sheen 3.4s ease-in-out infinite;}
@keyframes sheen{0%{left:-60%}45%{left:130%}100%{left:130%}}
.btn-ghost{color:var(--t1);border:1px solid var(--line-2);background:rgba(255,255,255,.022);font-weight:500;}
.btn-ghost:active{background:rgba(255,255,255,.06);}
.btn .arw{font-family:var(--mono);font-size:16px;line-height:1;transform:translateY(1px);}

/* ---------- quiz ---------- */
#s-quiz .pad{padding-top:calc(18px + env(safe-area-inset-top));}
.prog{position:relative;padding-bottom:6px;}
.prog-meta{display:flex;justify-content:space-between;align-items:baseline;font-size:10px;
  letter-spacing:.2em;text-transform:uppercase;color:var(--t2);margin-bottom:9px;}
.prog-meta .cnt{font-family:var(--mono);color:var(--t1);letter-spacing:.08em;}
.prog-meta .cnt b{color:var(--t0);font-weight:600;font-size:13px;display:inline-block;}
.prog-meta .cnt b.roll{animation:cntRoll .36s var(--ease) both;}
@keyframes cntRoll{from{opacity:0;transform:translateY(8px) scale(.82)}to{opacity:1;transform:none}}
.prog-track{position:relative;height:3px;border-radius:99px;background:rgba(255,255,255,.07);}
.prog-fill{position:absolute;left:0;top:0;bottom:0;width:0%;border-radius:99px;
  background:var(--acc-ramp);background-size:440px 100%;transition:width .5s var(--ease);}
.prog-head{position:absolute;top:50%;left:0%;width:9px;height:9px;border-radius:50%;
  transform:translate(-50%,-50%);background:#E8FFFA;
  box-shadow:0 0 10px 3px var(--acc-glow),0 0 22px 8px rgba(43,224,200,.32);
  transition:left .5s var(--ease);}
/* 10 格采样刻度 */
.prog-tick{position:absolute;top:50%;width:1px;height:5px;border-radius:1px;
  transform:translate(-50%,-50%);background:rgba(255,255,255,.15);
  transition:background .3s var(--ease),box-shadow .3s var(--ease);}
.prog-tick.on{background:#E8FFFA;box-shadow:0 0 6px var(--acc-glow);}
/* 每答一题，扫描头在原地炸开一圈 */
.prog-pulse{position:absolute;top:50%;left:0%;width:10px;height:10px;border-radius:50%;
  background:var(--acc-lt);opacity:0;pointer-events:none;
  transform:translate(-50%,-50%) scale(.6);}
.prog-pulse.go{animation:progPulse .62s var(--ease) .32s forwards;}
@keyframes progPulse{
  0%{opacity:.9;transform:translate(-50%,-50%) scale(.6)}
  100%{opacity:0;transform:translate(-50%,-50%) scale(6)}
}

.q-zone{position:relative;flex:1;display:flex;flex-direction:column;justify-content:center;
  padding:26px 0 10px;}
/* 换题时自上而下扫一道 */
.q-sweep{position:absolute;left:-22px;right:-22px;height:1px;top:0;opacity:0;pointer-events:none;z-index:3;
  background:linear-gradient(90deg,transparent,rgba(138,246,232,.8),transparent);
  box-shadow:0 0 14px rgba(43,224,200,.55);}
.q-sweep.go{animation:qSweep .64s cubic-bezier(.4,0,.6,1) forwards;}
@keyframes qSweep{0%{top:0;opacity:0}12%{opacity:1}100%{top:100%;opacity:0}}

.kbd-hint{position:absolute;left:0;right:0;bottom:2px;text-align:center;font-size:10.5px;
  letter-spacing:.08em;color:var(--t2);opacity:0;pointer-events:none;display:none;
  transition:opacity .5s var(--ease);}
@media(hover:hover) and (pointer:fine){ .kbd-hint{display:block;} }
.kbd-hint.show{opacity:1;}
.kbd-hint b{font-family:var(--mono);font-weight:600;color:var(--acc-lt);font-size:10px;
  border:1px solid var(--line-2);border-radius:4px;padding:0 4px;margin:0 1px;}

.q-block{will-change:transform,opacity;}
.q-block.out{animation:qOut .22s var(--ease) forwards;}
.q-block.in{animation:qIn .44s var(--ease) both;}
@keyframes qOut{to{opacity:0;transform:translate3d(-22px,0,0);}}
@keyframes qIn{from{transform:translate3d(24px,0,0);}to{transform:none;}}
/* 题干 → 选项 逐级落位 */
.q-block.in .stg{animation:stgIn .46s var(--ease) both;animation-delay:calc(var(--i,0) * 54ms);}
@keyframes stgIn{from{opacity:0;transform:translate3d(0,12px,0);}to{opacity:1;transform:none;}}
.q-idx{display:flex;align-items:center;gap:10px;font-size:10px;letter-spacing:.22em;color:var(--acc);margin-bottom:14px;}
.q-idx .bar{width:22px;height:1px;background:linear-gradient(90deg,var(--acc),transparent);}
.q-text{font-size:clamp(20px,5.6vw,24px);font-weight:700;line-height:1.5;letter-spacing:.01em;
  color:var(--t0);margin-bottom:26px;}
.opts{display:flex;flex-direction:column;gap:11px;}
.opt{position:relative;display:flex;align-items:center;gap:13px;width:100%;text-align:left;
  padding:15px 36px 15px 14px;border-radius:14px;border:1px solid var(--line);
  background:linear-gradient(180deg,rgba(255,255,255,.038),rgba(255,255,255,.014));overflow:hidden;
  transition:border-color .22s var(--ease),background .22s var(--ease),transform .3s var(--ease),
    opacity .42s var(--ease),filter .42s var(--ease),box-shadow .3s var(--ease);}
.opt::before{content:"";position:absolute;left:0;top:0;bottom:0;width:0%;
  background:linear-gradient(90deg,rgba(43,224,200,.26),rgba(138,246,232,.05));
  transition:width .55s var(--ease);}
.opt:active{transform:scale(.985);}
.opt .key{position:relative;flex:0 0 auto;width:27px;height:27px;border-radius:8px;display:grid;
  place-items:center;font-family:var(--mono);font-size:12px;font-weight:600;
  border:1px solid var(--line-2);color:var(--t1);transition:all .25s var(--ease);}
.opt .txt{position:relative;flex:1;font-size:14.5px;line-height:1.55;color:var(--t1);transition:color .25s;}
.opt .glow{position:absolute;left:100%;top:50%;width:118px;height:118px;
  transform:translate(-50%,-50%) scale(.55);opacity:0;border-radius:50%;
  background:radial-gradient(circle,rgba(43,224,200,.5),transparent 68%);
  filter:blur(16px);transition:opacity .3s,transform .45s var(--ease);pointer-events:none;}
/* 桌面端：柔光跟着指针走 */
.opt.hovering .glow{opacity:.45;transform:translate(-50%,-50%) scale(1);}
/* 点击涟漪 */
.opt .rip{position:absolute;width:18px;height:18px;border-radius:50%;pointer-events:none;
  transform:translate(-50%,-50%) scale(.3);opacity:.6;
  background:radial-gradient(circle,rgba(138,246,232,.7),rgba(43,224,200,0) 70%);
  animation:ripGo .68s var(--ease) forwards;}
@keyframes ripGo{to{transform:translate(-50%,-50%) scale(14);opacity:0}}
/* 右侧对勾（描边写入） */
.opt .chk{position:absolute;right:14px;top:50%;display:grid;place-items:center;
  color:var(--acc-lt);opacity:0;transform:translate(-5px,-50%);
  transition:opacity .26s var(--ease),transform .34s var(--ease);}
.opt .chk svg{width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:2.6;
  stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:26;stroke-dashoffset:26;
  transition:stroke-dashoffset .42s var(--ease) .12s;}
@media(hover:hover){
  .opt:hover{border-color:var(--line-2);background:rgba(255,255,255,.055);}
  .opt:hover .txt{color:var(--t0);}
  .opt::after{content:"";position:absolute;left:0;top:17%;bottom:17%;width:2px;border-radius:2px;
    background:linear-gradient(180deg,var(--acc-lt),var(--acc));
    opacity:0;transform:scaleY(.35);transition:opacity .26s var(--ease),transform .34s var(--ease);}
  .opt:hover::after{opacity:.65;transform:scaleY(1);}
  .opt.picked::after{opacity:1;transform:scaleY(1);}
}
.opt.picked{border-color:var(--acc-line);background:rgba(43,224,200,.07);
  box-shadow:0 0 0 1px rgba(43,224,200,.16),0 12px 28px -16px var(--acc-glow);}
.opt.picked::before{width:100%;}
.opt.picked .key{border-color:transparent;color:var(--acc-ink);
  background:linear-gradient(135deg,#8AF6E8,#2BE0C8);box-shadow:0 0 14px var(--acc-glow);
  animation:keyPop .42s var(--ease);}
@keyframes keyPop{0%{transform:scale(.8)}58%{transform:scale(1.16)}100%{transform:scale(1)}}
.opt.picked .txt{color:var(--t0);}
.opt.picked .glow{opacity:1;transform:translate(-50%,-50%) scale(1);}
.opt.picked .chk{opacity:1;transform:translate(0,-50%);}
.opt.picked .chk svg{stroke-dashoffset:0;}
/* 选定后，其余选项安静退到后面 */
.opts.settled .opt:not(.picked){opacity:.3;filter:saturate(.5);transform:scale(.972);}

/* ---------- scan ---------- */
#s-scan .pad{justify-content:center;align-items:center;}
.scan-wrap{position:relative;display:flex;flex-direction:column;align-items:center;gap:30px;}
.scan-line{position:absolute;left:-50vw;right:-50vw;height:1px;top:0;opacity:0;
  background:linear-gradient(90deg,transparent,rgba(138,246,232,.9),transparent);
  box-shadow:0 0 18px 3px var(--acc-glow);}
.scan-line.run{opacity:1;animation:scanDown 1.9s cubic-bezier(.4,0,.6,1) forwards;}
@keyframes scanDown{from{top:-14%}to{top:112%}}
.scan-ring-box{position:relative;width:min(62vw,250px);aspect-ratio:1;display:grid;place-items:center;}
.scan-ring-box::before{content:"";position:absolute;inset:-24%;border-radius:50%;
  background:radial-gradient(circle,rgba(43,224,200,.22),transparent 62%);
  filter:blur(26px);animation:corePulse 2.6s ease-in-out infinite;}
.scan-ring{width:100%;height:100%;transform:rotate(-90deg);}
.scan-ring circle{fill:none;stroke-width:3;stroke-linecap:round;}
.sr-bg{stroke:rgba(255,255,255,.08);}
.sr-fg{stroke:url(#scanGrad);filter:drop-shadow(0 0 7px var(--acc-glow));}
.scan-tick{position:absolute;inset:-6%;border-radius:50%;border:1px dashed rgba(43,224,200,.2);
  animation:spin 30s linear infinite reverse;}
.scan-center{position:absolute;display:flex;flex-direction:column;align-items:center;}
.scan-num{font-family:var(--mono);font-size:clamp(38px,12vw,52px);font-weight:600;line-height:1;
  letter-spacing:-.02em;color:#E8FFFA;text-shadow:0 0 26px var(--acc-glow);}
.scan-num i{font-size:.44em;font-style:normal;color:var(--acc-lt);margin-left:2px;vertical-align:top;}
.scan-unit{margin-top:9px;font-size:9px;letter-spacing:.26em;color:var(--t2);text-transform:uppercase;}
.scan-status{font-size:12px;letter-spacing:.14em;color:var(--t1);height:20px;
  display:flex;align-items:center;gap:8px;}
.scan-status .dot{width:5px;height:5px;border-radius:50%;background:var(--acc);
  animation:blip 1s ease-in-out infinite;}
.scan-log{font-size:10px;letter-spacing:.14em;color:var(--t2);height:16px;}

/* ---------- result ---------- */
#s-result .pad{gap:26px;}
.res-top{display:flex;justify-content:space-between;font-size:10px;letter-spacing:.18em;
  text-transform:uppercase;color:var(--t2);}
.res-hero{display:flex;flex-direction:column;align-items:center;text-align:center;}
.hero-ring{position:relative;width:min(54vw,206px);aspect-ratio:1;display:grid;place-items:center;margin-bottom:18px;}
.hero-ring::before{content:"";position:absolute;inset:-18%;border-radius:50%;
  background:radial-gradient(circle,var(--glow-a,#FF6B2C),transparent 62%);opacity:.3;filter:blur(26px);}
.hero-ring svg{width:100%;height:100%;transform:rotate(-90deg);}
.hero-ring circle{fill:none;stroke-width:4;stroke-linecap:round;}
.hr-bg{stroke:rgba(255,255,255,.075);}
.hr-fg{stroke:url(#ringGrad);filter:drop-shadow(0 0 8px var(--glow-b,#FF9A2E));}
.hero-center{position:absolute;display:flex;flex-direction:column;align-items:center;}
.hero-num{font-family:var(--mono);font-size:clamp(40px,12.5vw,54px);font-weight:600;line-height:1;
  letter-spacing:-.03em;color:#FFF6E2;text-shadow:0 0 30px var(--glow-b,#FF9A2E);}
.hero-num i{font-size:.4em;font-style:normal;color:var(--c-b,#FFB020);margin-left:3px;vertical-align:top;}
.hero-unit{margin-top:10px;font-size:9px;letter-spacing:.24em;color:var(--t2);}
.res-name{display:flex;align-items:center;gap:10px;margin-bottom:9px;}
.glyph{width:30px;height:30px;border-radius:9px;display:grid;place-items:center;
  border:1px solid var(--line-2);background:linear-gradient(140deg,var(--c-a,#5B8CFF),var(--c-b,#A9D6FF));
  color:#0B0A14;flex:0 0 auto;}
.glyph svg{width:17px;height:17px;fill:none;stroke:currentColor;stroke-width:1.7;
  stroke-linecap:round;stroke-linejoin:round;}
.res-name h2{font-size:clamp(26px,7.4vw,32px);font-weight:700;letter-spacing:.06em;color:var(--t0);}
.res-en{font-size:9.5px;letter-spacing:.3em;color:var(--c-t,#FFD166);text-transform:uppercase;margin-bottom:14px;}
.res-tagline{font-size:13.5px;line-height:1.7;color:var(--t1);max-width:310px;
  padding-top:14px;border-top:1px solid var(--line);}
.res-desc{font-size:13.5px;line-height:2;color:var(--t1);}
.sec-head{display:flex;align-items:baseline;gap:10px;margin-bottom:15px;}
.sec-head .sec-cn{font-size:13.5px;font-weight:600;color:var(--t0);letter-spacing:.06em;}
.sec-head .sec-en{font-size:9px;letter-spacing:.22em;color:var(--t2);text-transform:uppercase;}
.axis{position:relative;padding:0 1px;}
.axis-bar{position:relative;height:8px;border-radius:99px;background:var(--ramp);
  box-shadow:0 0 22px -4px rgba(255,140,60,.45);}
.axis-pin{position:absolute;top:50%;left:0%;width:14px;height:14px;border-radius:50%;
  transform:translate(-50%,-50%);background:#fff;border:3px solid var(--c-t,#FFD166);
  box-shadow:0 0 0 4px rgba(255,255,255,.12),0 0 16px 2px var(--glow-b,#FF9A2E);
  transition:left 1.1s var(--ease);}
.axis-chips{display:grid;grid-template-columns:repeat(6,1fr);gap:4px;margin-top:13px;}
.axis-chips span{text-align:center;font-size:10px;color:var(--t2);transition:color .3s;}
.axis-chips span.on{color:var(--c-t,#FFD166);font-weight:600;}
.ability-row{margin-bottom:16px;}
.ability-row:last-child{margin-bottom:0;}
.ab-head{display:flex;justify-content:space-between;align-items:baseline;margin-bottom:8px;}
.ab-cn{font-size:12.5px;color:var(--t1);letter-spacing:.04em;}
.ab-en{font-size:9px;letter-spacing:.16em;color:var(--t2);text-transform:uppercase;}
.ab-val{font-family:var(--mono);font-size:13px;font-weight:600;color:var(--c-t,#FFD166);}
.ab-track{height:5px;border-radius:99px;background:rgba(255,255,255,.07);overflow:hidden;}
.ab-fill{height:100%;width:0%;border-radius:99px;
  background:linear-gradient(90deg,var(--c-a,#5B8CFF),var(--c-b,#A9D6FF));
  box-shadow:0 0 12px -1px var(--glow-b,#A9D6FF);transition:width 1s var(--ease);}
.kw-list{display:flex;flex-wrap:wrap;gap:8px;}
.kw{padding:7px 13px;border-radius:9px;font-size:12px;color:var(--t1);
  border:1px solid var(--line);background:rgba(255,255,255,.03);letter-spacing:.04em;}
.kw::before{content:"#";color:var(--c-t,#FFD166);margin-right:3px;font-family:var(--mono);
  font-size:11px;opacity:.8;}
.actions{display:flex;flex-direction:column;gap:11px;}
.foot-note{font-size:9.5px;line-height:1.7;color:rgba(245,242,251,.24);text-align:center;letter-spacing:.03em;}

.rv{opacity:0;}
#s-result.active .rv,#s-intro.active .rv{animation:rvIn .72s var(--ease) both;animation-delay:var(--d,0s);}
@keyframes rvIn{from{opacity:0;transform:translate3d(0,16px,0);}to{opacity:1;transform:none;}}

.toast{position:fixed;left:50%;bottom:calc(38px + env(safe-area-inset-bottom));
  transform:translate(-50%,26px);opacity:0;pointer-events:none;padding:12px 20px;
  border-radius:12px;z-index:60;background:rgba(28,20,44,.94);border:1px solid var(--line-2);
  -webkit-backdrop-filter:blur(14px);backdrop-filter:blur(14px);
  font-size:12.5px;color:var(--t0);white-space:nowrap;
  box-shadow:0 18px 40px -14px rgba(0,0,0,.9);
  transition:opacity .3s var(--ease),transform .34s var(--ease);}
.toast.show{opacity:1;transform:translate(-50%,0);}
.flash{position:fixed;inset:0;background:radial-gradient(circle at 50% 42%,#FFF6DE,transparent 62%);
  opacity:0;pointer-events:none;z-index:50;}
.flash.go{animation:flashGo .55s ease-out forwards;}
@keyframes flashGo{0%{opacity:0}18%{opacity:.6}100%{opacity:0}}

@media (max-height:660px){
  .intro-orb-wrap{min-height:150px;padding:8px 0;}
  .orb{width:min(48vw,180px);}
  .q-zone{padding:16px 0 6px;}
  .q-text{margin-bottom:18px;}
  .hero-ring{width:min(44vw,164px);}
}
@media (prefers-reduced-motion:reduce){
  *{animation-duration:.001ms!important;animation-iteration-count:1!important;transition-duration:.12s!important;}
}
</style>
</head>
<body>
<div class="app">
  <div class="bg intro-on" id="bg">
    <div class="blob blob-cold"></div>
    <div class="blob blob-violet"></div>
    <div class="blob blob-teal"></div>
    <div class="grid-wrap"><div class="grid"></div></div>

    <div class="bg-intro">
      <svg class="contour a" viewBox="0 0 390 844" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
        <g fill="none" stroke-width="1">
          <path d="M235.7 320.0C236.5 323.5 234.7 327.7 233.7 331.4C232.7 335.1 231.9 339.3 229.5 342.2C227.2 345.1 222.9 346.5 219.7 348.5C216.6 350.5 213.8 352.6 210.6 354.1C207.4 355.6 203.8 357.7 200.4 357.6C197.0 357.5 193.5 354.6 190.2 353.5C186.9 352.5 184.3 351.8 180.7 351.4C177.0 351.0 171.6 352.4 168.1 351.0C164.6 349.5 161.9 345.9 159.7 342.7C157.5 339.5 154.9 335.6 154.7 331.8C154.6 328.0 157.2 323.5 158.6 320.0C160.0 316.5 162.2 314.0 163.1 310.6C163.9 307.3 162.7 303.2 163.8 300.0C165.0 296.8 167.5 293.6 170.2 291.3C172.8 289.1 176.5 288.4 179.7 286.5C182.9 284.6 185.7 281.0 189.2 279.9C192.7 278.7 197.0 279.4 200.8 279.9C204.6 280.4 209.0 280.6 212.1 282.6C215.2 284.6 217.7 288.6 219.3 292.0C220.9 295.3 220.1 299.9 221.6 302.9C223.2 305.9 226.3 307.3 228.6 310.1C231.0 313.0 234.8 316.5 235.7 320.0Z" stroke="rgba(43,224,200,0.17)"/>
          <path d="M268.1 320.0C268.8 326.2 263.1 333.0 260.8 339.3C258.5 345.7 258.2 353.2 254.3 358.1C250.4 363.0 242.5 365.1 237.2 368.7C231.9 372.3 227.9 377.5 222.3 379.8C216.8 382.2 210.0 383.1 204.0 382.8C198.1 382.4 192.5 378.7 186.7 377.8C180.8 376.8 175.8 377.2 169.0 377.0C162.2 376.8 151.6 379.8 145.8 376.8C140.1 373.7 137.5 365.1 134.5 358.9C131.5 352.7 127.6 346.2 127.7 339.8C127.8 333.3 133.5 326.1 135.1 320.0C136.8 313.9 137.1 309.1 137.9 303.2C138.6 297.3 137.5 290.1 139.8 284.5C142.1 279.0 147.0 273.9 151.7 270.0C156.5 266.2 162.9 265.4 168.4 261.7C173.9 258.0 178.5 249.8 184.6 247.9C190.7 246.0 198.4 249.1 205.0 250.5C211.5 252.0 219.0 252.7 223.9 256.7C228.8 260.7 231.3 269.1 234.3 274.6C237.3 280.2 238.1 285.3 241.9 289.9C245.6 294.4 252.5 296.8 256.8 301.8C261.2 306.9 267.5 313.8 268.1 320.0Z" stroke="rgba(43,224,200,0.15)"/>
          <path d="M310.9 320.0C310.5 330.0 300.5 339.9 296.5 349.8C292.6 359.7 293.2 371.5 287.3 379.3C281.4 387.1 269.5 390.8 261.3 396.5C253.0 402.1 246.4 410.1 237.6 413.3C228.9 416.6 218.1 416.1 208.8 415.8C199.5 415.6 191.4 411.8 181.8 411.8C172.2 411.8 162.2 415.9 151.2 415.9C140.1 415.9 123.6 417.9 115.4 411.8C107.3 405.7 106.0 389.8 102.5 379.5C98.9 369.1 94.2 359.5 94.2 349.6C94.2 339.7 101.4 329.5 102.7 320.0C104.0 310.5 101.4 302.2 102.0 292.7C102.7 283.2 102.4 271.6 106.6 263.2C110.8 254.7 119.8 248.2 127.4 242.0C135.0 235.8 143.6 232.4 152.1 226.0C160.6 219.6 168.5 206.0 178.3 203.7C188.0 201.4 200.5 208.5 210.5 212.0C220.5 215.6 231.1 218.5 238.3 225.1C245.6 231.7 248.6 244.1 254.2 251.7C259.7 259.3 264.3 264.4 271.7 270.7C279.1 277.0 292.1 281.3 298.7 289.6C305.2 297.8 311.2 310.0 310.9 320.0Z" stroke="rgba(43,224,200,0.135)"/>
          <path d="M360.6 320.0C358.4 335.0 347.1 348.8 341.7 363.1C336.3 377.3 336.5 394.1 328.2 405.6C319.9 417.1 304.2 424.2 292.0 432.0C279.9 439.8 268.3 448.0 255.5 452.4C242.6 456.8 228.2 457.3 214.9 458.2C201.5 459.1 190.0 455.6 175.2 457.6C160.4 459.7 142.2 471.2 126.3 470.5C110.3 469.7 89.7 464.5 79.5 453.3C69.3 442.2 69.2 418.9 65.1 403.5C60.9 388.2 55.9 375.1 54.8 361.2C53.7 347.2 58.3 333.7 58.5 320.0C58.7 306.3 55.1 293.2 56.0 279.2C56.9 265.2 57.1 247.8 64.0 235.8C70.9 223.9 86.6 217.3 97.5 207.5C108.4 197.6 117.4 186.5 129.6 176.8C141.7 167.0 155.9 150.9 170.4 149.2C185.0 147.5 203.1 159.6 217.1 166.4C231.1 173.1 243.8 180.7 254.5 189.8C265.1 198.8 271.3 211.6 281.0 220.7C290.7 229.8 300.5 235.6 312.8 244.3C325.1 253.0 346.9 260.4 354.8 273.1C362.8 285.7 362.8 305.0 360.6 320.0Z" stroke="rgba(43,224,200,0.12)"/>
          <path d="M417.2 320.0C412.8 341.3 406.0 360.4 399.6 380.1C393.2 399.8 390.3 422.1 378.7 438.1C367.1 454.0 346.9 465.6 329.8 475.6C312.7 485.5 294.0 491.2 276.2 497.8C258.4 504.3 241.3 511.0 223.0 514.7C204.7 518.5 187.8 515.7 166.2 520.3C144.6 524.8 114.7 545.5 93.6 542.0C72.5 538.6 51.6 517.8 39.6 499.4C27.5 481.0 27.0 452.2 21.4 431.6C15.8 410.9 9.9 394.1 6.1 375.5C2.3 356.9 -0.2 338.9 -1.4 320.0C-2.6 301.1 -3.3 282.1 -1.3 262.4C0.7 242.6 0.5 217.9 10.6 201.5C20.8 185.1 44.9 179.0 59.7 163.9C74.5 148.7 82.5 123.7 99.4 110.7C116.3 97.6 140.4 85.0 161.3 85.7C182.2 86.3 205.9 104.0 224.6 114.4C243.2 124.9 257.7 137.9 273.4 148.3C289.1 158.8 303.0 167.1 318.8 177.1C334.6 187.2 350.2 196.3 368.0 208.8C385.8 221.4 417.4 233.7 425.6 252.3C433.8 270.8 421.5 298.7 417.2 320.0Z" stroke="rgba(43,224,200,0.11)"/>
          <path d="M485.1 320.0C479.1 349.2 482.0 375.7 474.8 402.2C467.7 428.6 458.8 458.0 442.1 478.8C425.4 499.7 398.0 514.6 374.6 527.3C351.3 540.0 325.7 544.0 302.3 554.9C278.9 565.7 258.9 583.8 234.2 592.5C209.4 601.1 183.9 600.7 153.7 607.0C123.6 613.3 79.7 639.7 53.3 630.3C26.9 620.9 9.4 578.0 -4.8 550.6C-19.0 523.1 -22.5 491.6 -31.6 465.7C-40.8 439.7 -51.8 419.1 -59.9 394.8C-67.9 370.6 -77.8 345.6 -80.0 320.0C-82.3 294.4 -77.2 268.2 -73.3 241.2C-69.5 214.2 -70.4 180.9 -56.7 158.2C-43.0 135.6 -10.6 127.4 9.0 105.3C28.5 83.2 36.8 40.9 60.5 25.5C84.1 10.0 122.1 7.8 150.8 12.7C179.6 17.7 208.4 42.0 233.1 55.4C257.7 68.7 275.6 82.8 298.7 92.9C321.9 102.9 348.2 104.3 371.9 115.8C395.7 127.3 418.1 143.2 441.2 161.8C464.4 180.3 503.6 200.9 510.9 227.2C518.2 253.6 491.1 290.8 485.1 320.0Z" stroke="rgba(43,224,200,0.1)"/>
          <path d="M572.1 320.0C565.6 358.6 578.7 395.2 570.3 430.2C561.8 465.1 545.3 503.6 521.3 529.7C497.3 555.8 456.6 569.4 426.1 586.7C395.5 603.9 367.5 614.6 338.0 633.2C308.6 651.8 282.9 683.0 249.4 698.1C215.8 713.2 177.3 718.3 136.9 723.8C96.6 729.3 39.3 750.3 7.2 731.2C-24.9 712.1 -38.1 646.4 -55.7 609.3C-73.2 572.2 -82.1 539.6 -98.2 508.4C-114.2 477.2 -138.6 453.2 -151.8 421.8C-165.0 390.4 -175.1 354.6 -177.4 320.0C-179.7 285.4 -171.7 250.1 -165.7 214.1C-159.7 178.1 -159.0 135.3 -141.4 103.8C-123.9 72.3 -86.4 55.3 -60.5 25.1C-34.7 -5.0 -19.6 -61.2 13.7 -77.1C46.9 -92.9 100.7 -80.7 138.9 -70.0C177.1 -59.4 210.1 -26.8 242.9 -13.2C275.7 0.5 302.3 4.2 335.7 12.0C369.0 19.8 409.9 18.7 443.2 33.6C476.5 48.4 508.0 73.6 535.7 101.0C563.4 128.5 603.2 161.9 609.3 198.4C615.4 234.8 578.6 281.4 572.1 320.0Z" stroke="rgba(43,224,200,0.088)"/>
          <path d="M687.0 320.0C681.4 369.8 698.6 419.2 687.0 464.5C675.4 509.7 650.8 559.6 617.2 591.4C583.7 623.2 523.5 629.6 485.5 655.2C447.5 680.9 425.2 714.9 389.2 745.3C353.2 775.6 315.0 816.2 269.4 837.3C223.8 858.5 167.5 872.0 115.6 872.4C63.6 872.7 -3.4 871.5 -42.2 839.4C-81.0 807.4 -93.4 726.1 -117.1 680.2C-140.7 634.2 -157.7 600.7 -184.3 563.7C-210.9 526.8 -258.6 499.1 -276.7 458.5C-294.7 417.9 -291.0 366.6 -292.5 320.0C-294.0 273.4 -293.0 226.4 -285.6 178.9C-278.3 131.4 -270.6 78.4 -248.4 35.0C-226.3 -8.4 -187.8 -43.6 -152.8 -81.4C-117.9 -119.3 -85.2 -178.3 -38.9 -192.1C7.5 -205.9 76.4 -179.8 125.4 -164.1C174.4 -148.5 211.0 -107.8 255.1 -98.2C299.2 -88.6 343.5 -111.4 389.9 -106.7C436.3 -102.1 489.6 -92.6 533.4 -70.5C577.2 -48.5 621.6 -13.6 652.8 25.8C684.1 65.1 715.2 116.6 720.9 165.6C726.6 214.6 692.7 270.2 687.0 320.0Z" stroke="rgba(43,224,200,0.076)"/>
          <path d="M836.4 320.0C832.2 382.9 843.3 447.9 825.4 505.1C807.5 562.3 773.5 624.0 729.1 663.2C684.7 702.4 603.8 700.3 559.2 740.3C514.6 780.3 505.4 857.7 461.4 903.3C417.3 948.9 356.6 989.8 294.8 1013.8C232.9 1037.8 155.3 1057.4 90.4 1047.3C25.6 1037.3 -46.8 999.7 -94.2 953.3C-141.7 907.0 -160.4 822.1 -194.4 769.4C-228.4 716.7 -258.2 681.2 -298.5 637.2C-338.8 593.2 -414.7 558.2 -436.1 505.3C-457.5 452.5 -426.1 382.0 -426.9 320.0C-427.8 258.0 -448.2 195.3 -441.1 133.2C-434.0 71.2 -413.4 5.4 -384.5 -52.4C-355.5 -110.2 -315.6 -169.9 -267.4 -213.6C-219.1 -257.3 -157.8 -304.9 -94.9 -314.8C-32.0 -324.7 48.7 -289.6 109.8 -272.8C170.9 -256.0 212.5 -214.2 271.8 -214.0C331.0 -213.9 403.6 -274.9 465.3 -271.9C527.0 -268.9 587.7 -230.7 642.1 -196.0C696.5 -161.2 756.9 -117.3 791.7 -63.4C826.4 -9.5 843.3 63.5 850.8 127.4C858.2 191.4 840.6 257.1 836.4 320.0Z" stroke="rgba(43,224,200,0.064)"/>
          <path d="M1018.1 320.0C1014.2 398.5 1012.2 481.3 984.8 551.9C957.4 622.5 908.2 692.9 853.9 743.5C799.6 794.0 708.4 793.9 658.9 855.4C609.4 916.9 612.5 1050.7 556.9 1112.5C501.3 1174.3 407.5 1205.6 325.3 1225.9C243.0 1246.3 142.8 1259.6 63.5 1234.8C-15.9 1210.1 -91.6 1136.2 -150.9 1077.3C-210.1 1018.5 -242.2 939.2 -291.9 882.0C-341.7 824.7 -394.0 787.6 -449.2 734.0C-504.4 680.4 -600.1 629.2 -623.2 560.2C-646.2 491.2 -585.1 400.8 -587.5 320.0C-589.8 239.2 -642.7 155.9 -637.3 75.6C-631.8 -4.7 -594.9 -88.9 -554.7 -161.8C-514.4 -234.7 -462.7 -315.0 -395.8 -361.9C-329.0 -408.8 -234.8 -436.7 -153.6 -443.2C-72.4 -449.7 16.5 -411.4 91.4 -400.8C166.2 -390.3 217.3 -366.4 295.6 -379.9C373.9 -393.4 482.5 -488.3 561.2 -481.8C639.8 -475.3 703.0 -393.7 767.5 -340.8C832.1 -287.8 908.1 -234.4 948.3 -164.1C988.4 -93.8 996.9 0.4 1008.6 81.1C1020.2 161.8 1022.1 241.5 1018.1 320.0Z" stroke="rgba(43,224,200,0.052)"/>
        </g>
      </svg>
      <svg class="contour b" viewBox="0 0 390 844" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
        <g fill="none" stroke-width="1">
          <path d="M247.8 346.0C247.1 351.2 249.0 356.2 247.8 360.9C246.6 365.6 244.1 370.8 240.7 374.1C237.2 377.4 231.1 378.2 227.2 380.8C223.2 383.4 220.7 386.5 216.9 389.6C213.2 392.6 209.3 396.9 204.6 399.1C200.0 401.3 194.2 402.6 188.8 402.7C183.5 402.9 176.4 403.2 172.4 400.0C168.3 396.8 167.0 388.2 164.6 383.4C162.2 378.6 160.5 375.0 157.8 371.2C155.2 367.3 150.5 364.4 148.6 360.2C146.7 356.0 146.8 350.8 146.6 346.0C146.5 341.2 146.8 336.4 147.5 331.5C148.3 326.6 149.0 321.1 151.3 316.6C153.6 312.2 157.7 308.7 161.3 304.8C164.9 300.8 168.0 294.5 172.8 292.9C177.5 291.4 184.7 294.0 189.8 295.6C194.8 297.3 198.7 301.5 203.2 302.6C207.8 303.8 212.2 301.8 216.9 302.4C221.7 302.9 227.2 303.7 231.8 305.9C236.3 308.1 240.8 311.7 244.1 315.7C247.4 319.7 250.9 324.9 251.5 330.0C252.2 335.0 248.4 340.8 247.8 346.0Z" stroke="rgba(140,122,238,0.12)"/>
          <path d="M283.4 346.0C282.8 354.5 284.6 363.3 282.2 371.0C279.9 378.8 275.4 387.2 269.4 392.5C263.4 397.8 252.4 397.6 246.3 402.9C240.2 408.1 238.6 418.0 232.6 424.0C226.6 430.1 218.7 435.9 210.4 439.2C202.1 442.6 191.7 445.2 182.9 444.1C174.1 442.9 164.0 438.5 157.6 432.3C151.2 426.1 148.7 414.2 144.2 406.9C139.7 399.6 135.9 394.7 130.5 388.7C125.2 382.7 115.1 378.0 112.2 370.9C109.2 363.8 113.0 354.3 112.9 346.0C112.8 337.7 110.4 329.2 111.5 320.9C112.5 312.5 115.1 303.6 118.9 295.8C122.8 288.0 128.3 280.2 134.8 274.2C141.2 268.2 149.1 261.2 157.6 259.7C166.0 258.2 177.1 263.0 185.4 265.4C193.7 267.8 199.4 273.7 207.4 274.0C215.3 274.2 224.8 266.5 233.1 266.9C241.4 267.3 249.8 271.9 257.2 276.5C264.6 281.1 272.7 287.0 277.5 294.2C282.3 301.5 285.0 311.3 285.9 319.9C286.9 328.5 284.1 337.5 283.4 346.0Z" stroke="rgba(140,122,238,0.11)"/>
          <path d="M329.8 346.0C329.2 358.7 329.2 372.1 324.8 383.5C320.5 395.0 312.8 406.6 303.9 414.7C295.0 422.8 279.9 422.5 271.7 432.2C263.5 441.9 263.9 462.9 254.9 472.8C245.9 482.7 231.2 488.3 218.0 491.9C204.8 495.4 188.6 498.0 175.7 494.2C162.8 490.5 150.3 478.9 140.7 469.3C131.1 459.7 126.1 446.3 118.3 436.9C110.4 427.4 102.3 421.2 93.5 412.5C84.6 403.8 68.9 395.8 65.1 384.7C61.3 373.6 70.9 359.0 70.5 346.0C70.2 333.0 62.2 319.6 63.2 306.7C64.1 293.8 69.9 280.2 76.3 268.4C82.7 256.6 90.8 243.6 101.5 235.8C112.2 228.0 127.1 222.9 140.2 221.7C153.4 220.6 168.0 227.0 180.2 229.0C192.3 231.0 200.6 235.7 213.1 233.8C225.7 231.9 242.9 216.6 255.7 217.5C268.4 218.5 278.9 231.0 289.4 239.3C300.0 247.7 312.3 256.4 318.9 267.7C325.4 279.0 326.9 294.3 328.7 307.3C330.5 320.4 330.4 333.3 329.8 346.0Z" stroke="rgba(140,122,238,0.1)"/>
          <path d="M389.0 346.0C387.9 364.1 385.8 383.3 378.7 399.3C371.6 415.4 358.1 429.4 346.5 442.1C334.9 454.8 319.2 458.9 309.1 475.3C298.9 491.7 299.3 526.3 285.8 540.4C272.2 554.5 247.5 557.8 227.7 559.9C208.0 561.9 185.3 560.2 167.3 552.8C149.2 545.5 133.4 528.4 119.5 515.7C105.6 503.0 96.6 488.5 83.6 476.9C70.6 465.2 54.6 458.3 41.7 445.8C28.7 433.4 10.6 418.7 5.9 402.1C1.3 385.5 15.2 365.1 13.8 346.0C12.5 326.9 -3.1 306.6 -2.2 287.5C-1.3 268.5 8.5 248.0 19.2 231.7C29.9 215.5 45.0 199.2 61.8 189.9C78.5 180.7 100.8 177.5 119.4 176.1C138.0 174.8 156.3 182.2 173.4 181.7C190.4 181.3 203.1 178.4 221.8 173.4C240.5 168.4 267.6 148.7 285.7 151.8C303.8 154.9 316.3 178.3 330.4 192.1C344.5 205.9 361.0 218.3 370.2 234.7C379.5 251.1 382.6 272.0 385.7 290.6C388.8 309.1 390.2 327.9 389.0 346.0Z" stroke="rgba(140,122,238,0.09)"/>
          <path d="M459.6 346.0C457.0 371.1 455.4 397.2 445.4 418.9C435.4 440.6 413.3 456.3 399.7 476.3C386.1 496.2 376.3 513.5 363.9 538.6C351.6 563.8 346.2 610.0 325.4 627.2C304.7 644.5 267.5 643.5 239.6 642.0C211.6 640.4 182.5 628.8 157.9 617.9C133.3 606.9 111.8 591.1 91.8 576.3C71.9 561.5 58.2 543.5 38.3 529.2C18.4 514.8 -10.3 508.0 -27.4 490.2C-44.6 472.5 -58.6 446.9 -64.6 422.8C-70.6 398.8 -59.5 372.7 -63.3 346.0C-67.0 319.3 -88.7 289.4 -87.0 262.6C-85.2 235.9 -70.2 206.0 -52.7 185.5C-35.2 165.0 -6.3 150.5 18.1 139.5C42.5 128.6 69.3 123.3 93.7 119.8C118.1 116.4 140.9 124.4 164.3 118.8C187.8 113.2 208.0 94.1 234.4 86.2C260.7 78.3 298.0 63.3 322.5 71.3C346.9 79.2 362.4 113.4 380.8 133.9C399.2 154.4 419.5 172.0 432.8 194.4C446.2 216.9 456.4 243.3 460.9 268.5C465.4 293.8 462.1 320.9 459.6 346.0Z" stroke="rgba(140,122,238,0.082)"/>
          <path d="M541.7 346.0C537.0 379.9 540.9 414.2 529.1 443.5C517.3 472.8 485.4 491.1 470.8 522.0C456.3 552.8 458.0 593.4 441.9 628.6C425.7 663.8 405.3 715.2 373.8 733.2C342.4 751.2 290.9 743.3 253.2 736.6C215.4 729.9 180.2 706.1 147.1 693.0C114.0 679.9 82.4 674.1 54.4 658.1C26.5 642.2 7.7 615.8 -20.8 597.3C-49.2 578.8 -94.5 572.1 -116.1 547.2C-137.6 522.3 -141.5 481.5 -150.3 448.0C-159.1 414.5 -161.4 382.2 -168.9 346.0C-176.3 309.8 -199.9 266.9 -194.8 231.0C-189.7 195.0 -165.8 154.9 -138.3 130.5C-110.8 106.1 -62.6 98.6 -29.6 84.5C3.4 70.4 29.7 54.7 59.9 45.8C90.1 36.8 119.8 43.9 151.7 30.8C183.6 17.7 215.8 -23.7 251.5 -32.7C287.1 -41.8 333.9 -39.4 365.8 -23.6C397.7 -7.8 418.6 34.4 442.9 62.3C467.2 90.2 492.5 114.2 511.6 143.8C530.7 173.5 552.4 206.5 557.5 240.2C562.5 273.9 546.4 312.1 541.7 346.0Z" stroke="rgba(140,122,238,0.072)"/>
          <path d="M641.9 346.0C635.4 391.1 649.9 435.3 638.7 475.7C627.4 516.1 589.5 542.7 574.3 588.5C559.2 634.3 571.4 705.3 547.7 750.7C524.0 796.2 478.7 845.4 432.2 861.1C385.7 876.8 318.6 856.4 268.7 844.8C218.8 833.1 177.2 803.8 133.0 791.3C88.8 778.8 42.1 787.1 3.4 769.9C-35.3 752.7 -60.8 713.2 -99.4 688.0C-137.9 662.9 -200.4 653.5 -227.8 619.0C-255.1 584.5 -249.2 526.7 -263.5 481.2C-277.7 435.7 -301.7 394.4 -313.1 346.0C-324.6 297.6 -345.1 237.0 -332.2 190.6C-319.4 144.2 -276.8 96.6 -236.0 67.7C-195.2 38.9 -129.0 38.5 -87.5 17.6C-46.1 -3.2 -24.0 -38.4 12.8 -57.4C49.6 -76.4 89.9 -74.9 133.4 -96.5C176.9 -118.1 226.2 -180.0 273.6 -186.9C321.1 -193.9 376.8 -164.6 418.1 -138.1C459.4 -111.7 488.3 -64.1 521.4 -28.3C554.5 7.4 590.7 37.4 616.7 76.3C642.8 115.1 673.5 159.9 677.7 204.9C681.8 249.8 648.4 300.9 641.9 346.0Z" stroke="rgba(140,122,238,0.062)"/>
          <path d="M762.2 346.0C756.8 404.3 784.0 460.4 776.7 516.2C769.3 572.0 735.3 617.5 718.3 681.0C701.2 744.4 711.3 843.3 674.4 896.9C637.4 950.5 561.7 992.1 496.8 1002.5C431.9 1012.8 348.9 972.3 285.1 958.9C221.4 945.5 171.7 930.4 114.2 921.9C56.7 913.4 -7.7 928.2 -59.7 908.0C-111.6 887.9 -147.7 835.4 -197.4 801.1C-247.0 766.9 -322.0 748.5 -357.6 702.4C-393.3 656.3 -389.1 584.0 -411.4 524.6C-433.7 465.2 -478.0 409.5 -491.4 346.0C-504.9 282.5 -518.2 200.6 -492.0 143.7C-465.8 86.8 -389.3 39.8 -334.2 4.6C-279.0 -30.5 -208.5 -34.2 -161.0 -67.2C-113.6 -100.2 -94.3 -159.9 -49.3 -193.3C-4.3 -226.7 50.7 -239.1 108.8 -267.5C166.9 -296.0 237.4 -363.4 299.1 -364.0C360.7 -364.6 426.1 -308.8 478.7 -270.8C531.3 -232.8 569.4 -179.6 614.6 -136.0C659.8 -92.4 717.4 -59.6 749.8 -9.3C782.3 41.1 807.3 107.0 809.4 166.2C811.4 225.4 767.7 287.7 762.2 346.0Z" stroke="rgba(140,122,238,0.054)"/>
          <path d="M915.8 346.0C917.2 419.8 955.8 492.1 954.9 568.5C954.0 645.0 933.8 722.8 910.4 804.5C887.1 886.2 872.0 1000.4 814.7 1058.9C757.4 1117.4 651.9 1151.2 566.7 1155.5C481.4 1159.8 382.9 1094.0 303.2 1084.8C223.5 1075.5 161.5 1102.2 88.6 1099.9C15.7 1097.7 -66.6 1098.1 -134.3 1071.4C-201.9 1044.7 -255.0 985.0 -317.5 939.8C-380.0 894.5 -461.2 859.6 -509.5 800.0C-557.7 740.4 -575.2 657.7 -607.0 582.1C-638.7 506.4 -689.6 427.7 -700.0 346.0C-710.3 264.3 -713.6 159.1 -668.9 91.7C-624.2 24.4 -499.4 -12.0 -431.8 -58.1C-364.2 -104.2 -313.4 -133.0 -263.1 -185.0C-212.8 -236.9 -186.7 -319.8 -129.9 -369.8C-73.1 -419.8 1.4 -453.8 77.5 -485.0C153.6 -516.2 247.9 -566.3 326.8 -557.0C405.7 -547.7 484.5 -477.9 551.0 -429.1C617.5 -380.4 665.6 -317.0 726.0 -264.5C786.4 -212.1 876.6 -179.5 913.4 -114.4C950.2 -49.3 946.3 49.1 946.7 125.9C947.1 202.6 914.5 272.2 915.8 346.0Z" stroke="rgba(140,122,238,0.046)"/>
        </g>
      </svg>
      <div class="beam"></div>
      <div class="dust" id="dust"></div>
    </div>

    <div class="scanlines"></div>
    <div class="noise"></div>
    <div class="vign"></div>

    <div class="edge-ruler l"></div>
    <div class="edge-ruler r"></div>
    <div class="corner tl"></div>
    <div class="corner tr"></div>
    <div class="corner bl"></div>
    <div class="corner br"></div>
  </div>

  <div class="stage">

    <!-- ============ INTRO ============ -->
    <section class="screen active" id="s-intro">
      <div class="pad">
        <div class="hud rv" style="--d:.02s">
          <span class="hud-l"><i class="dot"></i>THERMAL SCAN</span>
          <span>BIOMETRIC SERIES 01</span>
        </div>

        <div class="intro-orb-wrap">
          <div class="orb">
            <div class="orb-sweep"></div>
            <div class="orb-core"></div>
            <svg class="orb-svg" viewBox="0 0 260 260" aria-hidden="true">
              <circle class="ring-tick" cx="130" cy="130" r="120"/>
              <circle class="ring-thin" cx="130" cy="130" r="100"/>
              <circle class="ring-acc" cx="130" cy="130" r="74"/>
              <circle class="ring-thin" cx="130" cy="130" r="46"/>
              <line class="tick-lg" x1="130" y1="4" x2="130" y2="22"/>
              <line class="tick-lg" x1="130" y1="238" x2="130" y2="256"/>
              <line class="tick-lg" x1="4" y1="130" x2="22" y2="130"/>
              <line class="tick-lg" x1="238" y1="130" x2="256" y2="130"/>
              <line x1="130" y1="52" x2="130" y2="86" stroke="rgba(43,224,200,.32)" stroke-width="1"/>
              <line x1="130" y1="174" x2="130" y2="208" stroke="rgba(43,224,200,.32)" stroke-width="1"/>
              <line x1="52" y1="130" x2="86" y2="130" stroke="rgba(43,224,200,.32)" stroke-width="1"/>
              <line x1="174" y1="130" x2="208" y2="130" stroke="rgba(43,224,200,.32)" stroke-width="1"/>
            </svg>
          </div>
        </div>

        <div class="intro-txt">
          <div class="intro-kicker rv" style="--d:.1s">Emotional Thermal Index</div>
          <h1 class="intro-title rv" style="--d:.16s">情绪温度测试</h1>
          <div class="intro-sub rv" style="--d:.22s">找到你的情绪热值原型</div>
          <p class="intro-desc rv" style="--d:.3s">
            每个人处理情绪时，都有一个固定的「工作温度」。<br>
            有人常年低温运行，有人一点就燃。<br>
            10 道题，测出你的情绪热值和属于它的原型。
          </p>
          <div class="intro-meta rv" style="--d:.38s">
            <span class="chip"><b>10</b> 道题</span>
            <span class="chip"><b>6</b> 种原型</span>
            <span class="chip">约 <b>2</b> 分钟</span>
          </div>
        </div>

        <div class="rv" style="--d:.46s;margin-top:auto;">
          <button class="btn btn-primary" id="btnStart">开始扫描 <span class="arw">→</span></button>
        </div>
      </div>
    </section>

    <!-- ============ QUIZ ============ -->
    <section class="screen" id="s-quiz">
      <div class="pad">
        <div class="prog">
          <div class="prog-meta">
            <span>THERMAL SCAN · IN PROGRESS</span>
            <span class="cnt"><b id="qNow">01</b> / 10</span>
          </div>
          <div class="prog-track">
            <div class="prog-fill" id="progFill"></div>
            <div class="prog-head" id="progHead"></div>
            <div class="prog-pulse" id="progPulse"></div>
          </div>
        </div>

        <div class="q-zone">
          <div class="q-sweep" id="qSweep"></div>
          <div class="kbd-hint" id="kbdHint">按 <b>1</b>–<b>4</b> 或 <b>A</b>–<b>D</b> 键也能作答</div>
          <div class="q-block" id="qBlock">
            <div class="q-idx stg" style="--i:0"><span class="bar"></span><span id="qIdx">QUESTION 01</span></div>
            <h2 class="q-text stg" id="qText" style="--i:1"></h2>
            <div class="opts" id="qOpts"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- ============ SCAN ============ -->
    <section class="screen" id="s-scan">
      <div class="pad">
        <div class="scan-wrap">
          <div class="scan-line" id="scanLine"></div>
          <div class="scan-ring-box">
            <div class="scan-tick"></div>
            <svg class="scan-ring" viewBox="0 0 200 200" aria-hidden="true">
              <defs>
                <linearGradient id="scanGrad" x1="0" y1="0" x2="1" y2="1">
                  <stop offset="0%" stop-color="#0E9E92"/>
                  <stop offset="40%" stop-color="#2BE0C8"/>
                  <stop offset="72%" stop-color="#8AF6E8"/>
                  <stop offset="100%" stop-color="#E8FFFA"/>
                </linearGradient>
              </defs>
              <circle class="sr-bg" cx="100" cy="100" r="86"/>
              <circle class="sr-fg" id="scanRing" cx="100" cy="100" r="86"/>
            </svg>
            <div class="scan-center">
              <div class="scan-num"><span id="scanNum">0</span><i>°</i></div>
              <div class="scan-unit mono">Thermal Index</div>
            </div>
          </div>
          <div class="scan-status"><i class="dot"></i><span id="scanStatus">初始化热成像阵列</span></div>
          <div class="scan-log mono" id="scanLog">SAMPLING 00 / 10</div>
        </div>
      </div>
    </section>

    <!-- ============ RESULT ============ -->
    <section class="screen" id="s-result">
      <div class="pad">
        <div class="res-top rv" style="--d:.02s">
          <span>SCAN COMPLETE</span>
          <span>10 / 10 SAMPLES</span>
        </div>

        <div class="res-hero rv" style="--d:.1s">
          <div class="hero-ring">
            <svg viewBox="0 0 220 220" aria-hidden="true">
              <defs>
                <linearGradient id="ringGrad" x1="0" y1="0" x2="1" y2="1">
                  <stop offset="0%" stop-color="#5B8CFF"/>
                  <stop offset="100%" stop-color="#A9D6FF"/>
                </linearGradient>
              </defs>
              <circle class="hr-bg" cx="110" cy="110" r="92"/>
              <circle class="hr-fg" id="resRing" cx="110" cy="110" r="92"/>
            </svg>
            <div class="hero-center">
              <div class="hero-num"><span id="resTemp">0</span><i>°</i></div>
              <div class="hero-unit mono">THERMAL INDEX</div>
            </div>
          </div>

          <div class="res-name">
            <span class="glyph" id="resGlyph"></span>
            <h2 id="resName">—</h2>
          </div>
          <div class="res-en mono" id="resEn">—</div>
          <p class="res-tagline" id="resTagline">—</p>
        </div>

        <p class="res-desc rv" style="--d:.18s" id="resDesc">—</p>

        <div class="axis-wrap rv" style="--d:.26s">
          <div class="sec-head"><span class="sec-cn">温度坐标</span><span class="sec-en mono">Temperature Axis</span></div>
          <div class="axis">
            <div class="axis-bar"></div>
            <div class="axis-pin" id="axisPin"></div>
          </div>
          <div class="axis-chips" id="axisChips"></div>
        </div>

        <div class="ability-wrap rv" style="--d:.34s">
          <div class="sec-head"><span class="sec-cn">能力解码</span><span class="sec-en mono">Ability Decode</span></div>
          <div id="abilityList"></div>
        </div>

        <div class="kw-wrap rv" style="--d:.42s">
          <div class="sec-head"><span class="sec-cn">关键词</span><span class="sec-en mono">Keywords</span></div>
          <div class="kw-list" id="kwList"></div>
        </div>

        <div class="actions rv" style="--d:.5s">
          <button class="btn btn-primary" id="btnShare">分享我的温度 <span class="arw">↗</span></button>
          <button class="btn btn-ghost" id="btnRetry">重新测试</button>
        </div>
        <p class="foot-note rv" style="--d:.56s">
          本测试为趣味自我观察工具，结果基于行为偏好模型生成<br>不构成任何医学或心理诊断建议
        </p>
      </div>
    </section>

  </div>
</div>

<div class="flash" id="flash"></div>
<div class="toast" id="toast"></div>

<script>
(function(){
'use strict';

/* ============================================================
   1. DATA
   ============================================================ */
var ORDER = ['GL','DC','WS','FC','MG','AR'];

// 温度环:选项主类型 +2,环上相邻的下一档 +1 —— 形成平滑的温度梯度
var RING = { GL:'DC', DC:'WS', WS:'FC', FC:'MG', MG:'AR', AR:'GL' };

// 能力维度(6 种原型共用同一套维度,便于横向比较)
var ABI = [
  { k:'stable',  cn:'情绪稳定度', en:'STABILITY' },
  { k:'empathy', cn:'共情力',     en:'EMPATHY'   },
  { k:'drive',   cn:'行动力',     en:'DRIVE'     },
  { k:'recover', cn:'恢复力',     en:'RECOVERY'  },
  { k:'magnet',  cn:'感染力',     en:'MAGNETISM' }
];

var TYPES = {
  GL:{
    name:'冰川型', en:'GLACIER', thermal:14,
    cA:'#5B8CFF', cB:'#A9D6FF', cT:'#A9D6FF',
    tagline:'情绪被收进冰层，表面永远平整。',
    desc:'你有一套属于自己的温度调节机制。大多数时候，情绪还没浮到表面，就已经被你处理完了。别人看到的是「没什么反应」，其实你不是没有感觉，你只是不允许感觉接管方向盘。这让你在混乱里格外可靠，也让别人偶尔觉得读不懂你。你不冷，你只是把热留在了内部。',
    kw:['边界清晰','理性优先','低外显','独立','观察者'],
    ab:[94,46,62,78,51],
    glyph:'<path d="M12 2.5v19M3.9 7.2l16.2 9.6M20.1 7.2L3.9 16.8M12 6.4l2.8-2.2M12 6.4L9.2 4.2M12 17.6l2.8 2.2M12 17.6l-2.8 2.2"/>'
  },
  DC:{
    name:'深流型', en:'DEEP CURRENT', thermal:31,
    cA:'#37C2D8', cB:'#86E8E0', cT:'#86E8E0',
    tagline:'温度不高，但一直在稳定地流着。',
    desc:'你的情绪节奏比大多数人慢半拍，可一旦启动就很难停下。你不喜欢被推着走，也不喜欢在没想清楚之前表态。你身上有一种让人安心的恒定感，代价是这种恒定需要时间才能被外人读到。你建立的关系不多，但每一段都很深。',
    kw:['慢热','稳定','内蓄','可靠','深度连接'],
    ab:[86,68,55,88,60],
    glyph:'<path d="M2 9.2c2.6 0 3.4-3.4 6-3.4s3.4 3.4 6 3.4 3.4-3.4 6-3.4M2 15.4c2.6 0 3.4-3.4 6-3.4s3.4 3.4 6 3.4 3.4-3.4 6-3.4M4 21.4c2 0 2.7-2.2 4.6-2.2"/>'
  },
  WS:{
    name:'暖阳型', en:'WARM SUN', thermal:49,
    cA:'#FFD166', cB:'#FFA62B', cT:'#FFD166',
    tagline:'你总是先暖别人，再回来暖自己。',
    desc:'你对情绪极其敏感，而且是往温暖的方向敏感。你天然地知道一个人此刻需要什么，也愿意花力气把气氛调到舒服的位置。这是你的天赋，也是你的消耗点——别人情绪的降温你会照单全收。记得留一点温度给自己，你不是所有人的恒温器。',
    kw:['高共情','温和','关系优先','照顾型','吸收情绪'],
    ab:[72,93,64,70,82],
    glyph:'<circle cx="12" cy="12" r="4.2"/><path d="M12 2.4v3M12 18.6v3M2.4 12h3M18.6 12h3M5.2 5.2l2.1 2.1M16.7 16.7l2.1 2.1M18.8 5.2l-2.1 2.1M7.3 16.7l-2.1 2.1"/>'
  },
  FC:{
    name:'焰心型', en:'FLAME CORE', thermal:64,
    cA:'#FF8A3D', cB:'#FF5A2C', cT:'#FF9A5C',
    tagline:'目标出现的那一刻，温度直接拉满。',
    desc:'你的能量是有方向的。平时可以很平静，但只要认定一件事，热度会瞬间集中到一点，推动周围所有人跟着动起来。你的问题从来不是动力不足，而是怎么让别人跟上你的节奏。你不需要更多的热情，你需要的是偶尔把火调小一点。',
    kw:['行动力','目标导向','主动','高能量','推动者'],
    ab:[61,66,92,66,88],
    glyph:'<circle cx="12" cy="12" r="8.4"/><circle cx="12" cy="12" r="3.1" fill="currentColor" stroke="none"/>'
  },
  MG:{
    name:'熔岩型', en:'MAGMA', thermal:80,
    cA:'#FF4D6D', cB:'#C81E5B', cT:'#FF7A93',
    tagline:'情绪滚烫、真实，藏不住也不打算藏。',
    desc:'你很少说「还好」。喜欢是喜欢，难过是难过，全都写在脸上。这种浓度让身边的人爱得很清楚，也偶尔被烫到。但你从不记仇——炸完就翻篇，第二天照样掏心掏肺。你的真实本身就是一种力量，只是偶尔需要在开口之前，给自己多留三秒钟。',
    kw:['高敏感','真实直接','强度大','快速翻篇','浓度型'],
    ab:[44,78,81,74,90],
    glyph:'<path d="M1.9 20.6L9.2 5.5l4 7.5 2.9-4.3 6 11.9z"/>'
  },
  AR:{
    name:'电弧型', en:'ARC', thermal:94,
    cA:'#B06CFF', cB:'#F04BD8', cT:'#D98BF5',
    tagline:'你不是热，你是电流——快、亮、停不下来。',
    desc:'你的情绪不是慢慢升温的类型，而是瞬间放电。想法多、反应快、对新鲜刺激上瘾。你能在别人还在犹豫的时候抓住机会，代价是很少有人能跟上你思路的跳跃。与其强迫自己调慢，不如去找到那个接得住你节奏的人。',
    kw:['敏锐','高刺激需求','直觉强','创造力','跳跃思维'],
    ab:[52,61,86,58,79],
    glyph:'<path d="M13.4 2.2L4.6 13.6h5.6l-1.2 8.2 8.8-11.4h-5.6z"/>'
  }
};

/* 10 题 × 4 选项。每题覆盖 4 个不同主类型,10 题共 40 个选项位,
   6 类原型出现次数为 7/7/7/7/6/6 —— 保证每条路径都可达且分布均衡。 */
var QUESTIONS = [
  { q:'清晨刚醒来的那几分钟，你的状态最接近哪一种？',
    o:[ {t:'GL', x:'大脑像刚开机，还没加载任何情绪'},
        {t:'DC', x:'需要一点时间，才能慢慢「热」起来'},
        {t:'WS', x:'会不自觉想到今天要见到的人'},
        {t:'FC', x:'已经有一个念头在催你起床了'} ] },

  { q:'突然收到一条坏消息，你的第一反应是？',
    o:[ {t:'MG', x:'情绪先冲上来，根本拦不住'},
        {t:'AR', x:'脑子已经开始转：这事还能怎么解'},
        {t:'GL', x:'先沉默，把情绪压到后面再处理'},
        {t:'DC', x:'表面还好，但心里要消化很久'} ] },

  { q:'走进一个谁都不认识的房间，你通常会？',
    o:[ {t:'WS', x:'去找那个看起来也有点孤单的人搭话'},
        {t:'FC', x:'主动破冰，场子冷了我来热'},
        {t:'MG', x:'状态取决于现场有没有同频的人'},
        {t:'AR', x:'先四处走走，好奇每个人在聊什么'} ] },

  { q:'朋友向你倾诉烦恼时，你更常做的是？',
    o:[ {t:'WS', x:'先接住情绪，让他知道有人站在他这边'},
        {t:'GL', x:'帮他把事情拆开，看清问题到底在哪'},
        {t:'FC', x:'直接问「你想让我做什么」，然后去做'},
        {t:'DC', x:'安静听完，最后只说一句「我在」'} ] },

  { q:'高强度忙完一天，你怎么把自己「充回来」？',
    o:[ {t:'GL', x:'独处，把当天的信息一条条归档'},
        {t:'MG', x:'找人说个痛快，把情绪全部倒出来'},
        {t:'DC', x:'什么都不做，让情绪自己沉下去'},
        {t:'AR', x:'换一件新鲜的事，把脑子里的东西顶掉'} ] },

  { q:'遇到正面冲突时，你通常？',
    o:[ {t:'AR', x:'用一句玩笑岔开，再找机会单独聊'},
        {t:'MG', x:'先炸一下，但从来不记仇'},
        {t:'FC', x:'当面说清楚，不喜欢拖着'},
        {t:'WS', x:'尽量让双方都舒服，宁愿自己退一步'} ] },

  { q:'做一个重要决定时，你更依赖？',
    o:[ {t:'DC', x:'一段时间，等答案自己浮出来'},
        {t:'FC', x:'先跳进去，边走边修'},
        {t:'GL', x:'一张列满利弊和概率的清单'},
        {t:'WS', x:'问几个信得过的人，再自己定'} ] },

  { q:'别人形容你，最常出现的是哪一句？',
    o:[ {t:'AR', x:'「你脑子里好像同时开着好几个窗口」'},
        {t:'DC', x:'「和你在一起很稳，但不太看得透你」'},
        {t:'MG', x:'「你太真了，高兴难过全写在脸上」'},
        {t:'GL', x:'「你太冷静，好像没什么能影响你」'} ] },

  { q:'被误解的时候，你会？',
    o:[ {t:'FC', x:'立刻解释，必须把话当面说清楚'},
        {t:'WS', x:'会反复想，想不通的时候有点难受'},
        {t:'AR', x:'算了，不同频的人怎么解释都没用'},
        {t:'MG', x:'情绪当场就上来，说完也就过去了'} ] },

  { q:'如果用一个画面形容你情绪的节奏？',
    o:[ {t:'FC', x:'一条持续上扬、越走越快的曲线'},
        {t:'WS', x:'一圈均匀散开、慢慢变暖的热度'},
        {t:'DC', x:'一片缓慢涨落的潮汐'},
        {t:'GL', x:'一条几乎不波动的直线'} ] }
];

var LETTERS = ['A','B','C','D'];

/* ============================================================
   2. UTILS
   ============================================================ */
function $(id){ return document.getElementById(id); }
function clamp(v,a,b){ return v<a?a:(v>b?b:v); }
function pad2(n){ return n<10 ? '0'+n : ''+n; }

// 缓出,让数字增长更有"测量感"
function easeOut(t){ return 1 - Math.pow(1-t, 3); }

function animNum(el, to, dur, suffix, delay){
  suffix = suffix || '';
  var from = 0, t0 = null;
  setTimeout(function(){
    function step(ts){
      if(t0===null) t0 = ts;
      var p = Math.min(1, (ts-t0)/dur);
      el.textContent = Math.round(from + (to-from)*easeOut(p)) + suffix;
      if(p<1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }, delay||0);
}

function ringLen(el){ return 2*Math.PI*el.r.baseVal.value; }

function setRing(el, pct, dur){
  var c = ringLen(el);
  el.style.transition = 'none';
  el.style.strokeDasharray = c;
  el.style.strokeDashoffset = c;
  el.getBoundingClientRect();
  el.style.transition = 'stroke-dashoffset '+dur+'ms cubic-bezier(.22,1,.36,1)';
  el.style.strokeDashoffset = c*(1-pct/100);
}

/* ============================================================
   3. STATE
   ============================================================ */
var state = { qi:0, answers:[], scores:null, winner:'GL', thermal:50, jitter:[0,0,0,0,0], locked:false };

function resetState(){
  state.qi = 0;
  state.answers = [];
  state.scores = null;
  state.winner = 'GL';
  state.thermal = 50;
  state.jitter = [0,0,0,0,0];
  state.locked = false;
  chargeAmbient(0);
}

/* ============================================================
   4. SCREENS
   ============================================================ */
var screens = ['s-intro','s-quiz','s-scan','s-result'];
function show(id){
  screens.forEach(function(s){
    $(s).classList.toggle('active', s===id);
  });
  // 初始页专属的大气层只在首页出现，进题后收起，专注答题
  $('bg').classList.toggle('intro-on', id === 's-intro');
  var el = $(id);
  if(el) el.scrollTop = 0;
}

/* ============================================================
   5. QUIZ
   ============================================================ */
var qBlock = $('qBlock'), qText = $('qText'), qOpts = $('qOpts'), qIdx = $('qIdx');
var qNow = $('qNow'), progFill = $('progFill'), progHead = $('progHead'), progPulse = $('progPulse');
var qSweep = $('qSweep'), kbdHint = $('kbdHint');
var blobTeal = document.querySelector('.blob-teal');

/* 进度条上的 10 个采样刻度 */
var progTicks = [];
(function buildTicks(){
  var track = progFill.parentNode;
  for(var i=0;i<QUESTIONS.length;i++){
    var t = document.createElement('i');
    t.className = 'prog-tick';
    t.style.left = ((i + 0.5) / QUESTIONS.length * 100) + '%';
    track.appendChild(t);
    progTicks.push(t);
  }
})();

/* n = 已采样题数。进度条只在「答完一题」时才前进,读起来像热值在注入 */
function setProgress(n){
  n = clamp(n, 0, QUESTIONS.length);
  var pct = n / QUESTIONS.length * 100;
  progFill.style.width = pct + '%';
  progHead.style.left = pct + '%';
  progPulse.style.left = pct + '%';
  progTicks.forEach(function(t, i){ t.classList.toggle('on', i < n); });
  if(n > 0){
    progPulse.classList.remove('go');
    void progPulse.offsetWidth;
    progPulse.classList.add('go');
  }
}

/* 背景里的青色热源随答题缓慢蓄能 —— 用的是答对答错都一样的中性量 */
function chargeAmbient(n){
  if(blobTeal) blobTeal.style.opacity = (0.5 + 0.03 * n).toFixed(2);
}

function sweepQuestion(){
  qSweep.classList.remove('go');
  void qSweep.offsetWidth;
  qSweep.classList.add('go');
}

var kbdTimer = null;
function showKbdHint(){
  clearTimeout(kbdTimer);
  kbdHint.classList.add('show');
  kbdTimer = setTimeout(hideKbdHint, 4600);
}
function hideKbdHint(){
  clearTimeout(kbdTimer);
  kbdHint.classList.remove('show');
}

/* 从点击位置扩散一圈,像墨滴进水里 */
function ripple(el, ev){
  var r = el.getBoundingClientRect();
  var x = (ev && ev.clientX) ? ev.clientX - r.left : r.width * 0.2;
  var y = (ev && ev.clientY) ? ev.clientY - r.top  : r.height / 2;
  var s = document.createElement('span');
  s.className = 'rip';
  s.style.left = x + 'px';
  s.style.top = y + 'px';
  el.appendChild(s);
  setTimeout(function(){ if(s.parentNode) s.parentNode.removeChild(s); }, 720);
}

function renderQuestion(){
  var q = QUESTIONS[state.qi];
  qIdx.textContent = 'QUESTION ' + pad2(state.qi+1);
  qText.textContent = q.q;

  qNow.textContent = pad2(state.qi+1);
  qNow.classList.remove('roll');
  void qNow.offsetWidth;
  qNow.classList.add('roll');

  setProgress(state.qi);
  sweepQuestion();
  if(state.qi > 0) hideKbdHint();

  qOpts.classList.remove('settled');
  qOpts.innerHTML = '';
  q.o.forEach(function(op, i){
    var b = document.createElement('button');
    b.type = 'button';
    b.className = 'opt stg';
    b.style.setProperty('--i', i + 2);
    b.innerHTML =
      '<span class="key">'+LETTERS[i]+'</span>' +
      '<span class="txt">'+op.x+'</span>' +
      '<span class="chk"><svg viewBox="0 0 24 24"><path d="M4 12.5l5 5L20 6.8"/></svg></span>' +
      '<span class="glow"></span>';
    b.addEventListener('click', function(ev){ pick(i, b, ev); });
    qOpts.appendChild(b);
  });
}

function pick(i, el, ev){
  if(state.locked) return;
  state.locked = true;

  ripple(el, ev);
  if(navigator.vibrate){ try{ navigator.vibrate(12); }catch(err){} }

  // 入场动画交棒给选中态,否则两者会打架
  var all = qOpts.querySelectorAll('.opt');
  for(var k=0;k<all.length;k++) all[k].classList.remove('stg');

  el.classList.add('picked');
  qOpts.classList.add('settled');
  hideKbdHint();
  state.answers[state.qi] = i;

  setProgress(state.qi + 1);
  chargeAmbient(state.qi + 1);

  setTimeout(function(){
    state.locked = false;
    if(state.qi >= QUESTIONS.length-1){
      runScan();
    } else {
      nextQuestion();
    }
  }, 460);
}

function nextQuestion(){
  qBlock.classList.remove('in');
  qBlock.classList.add('out');
  setTimeout(function(){
    state.qi++;
    renderQuestion();
    qBlock.classList.remove('out');
    void qBlock.offsetWidth;
    qBlock.classList.add('in');
  }, 200);
}

/* ============================================================
   6. SCORING
   ============================================================ */
function computeResult(){
  var s = { GL:0, DC:0, WS:0, FC:0, MG:0, AR:0 };  // 加权总分
  var p = { GL:0, DC:0, WS:0, FC:0, MG:0, AR:0 };  // 主类型命中次数

  state.answers.forEach(function(oi, qi){
    var t = QUESTIONS[qi].o[oi].t;
    s[t] += 2;
    p[t] += 1;
    s[RING[t]] += 1;   // 温度环上的相邻档位获得少量加成
  });

  // 得分最高者胜;同分时优先「主类型命中更多」的一方,最后才按固定顺序
  var winner = ORDER[0], best = -1, bestP = -1;
  ORDER.forEach(function(k){
    if(s[k] > best || (s[k] === best && p[k] > bestP)){
      best = s[k];
      bestP = p[k];
      winner = k;
    }
  });

  // 热值 = 原型基准值 + 由得分强弱带来的个性化偏移
  var delta = clamp(Math.round((best - 10) * 1.6), -8, 8);
  var thermal = clamp(TYPES[winner].thermal + delta, 4, 99);

  // 由答案派生一个稳定 seed,让同类型结果也有细微差异
  var seed = 0;
  state.answers.forEach(function(a,i){ seed = (seed*31 + a*7 + i*13 + 17) % 997; });
  var jitter = [];
  for(var i=0;i<5;i++){ jitter.push(((seed >> i) % 9) - 4); }

  state.scores = s;
  state.winner = winner;
  state.thermal = thermal;
  state.jitter = jitter;
}

/* ============================================================
   7. SCAN ANIMATION
   ============================================================ */
var scanRing = $('scanRing'), scanNum = $('scanNum'), scanStatus = $('scanStatus'), scanLog = $('scanLog');
var scanLine = $('scanLine'), flashEl = $('flash');

function runScan(){
  computeResult();
  show('s-scan');

  var STEPS = [
    { t:'初始化热成像阵列',  log:'ARRAY INIT · OK' },
    { t:'校准情绪传感器',    log:'SENSOR CALIBRATED' },
    { t:'采集 10 组行为样本', log:'SAMPLING 10 / 10' },
    { t:'匹配 6 种温度原型',  log:'PATTERN MATCH 96%' },
    { t:'生成热值分布',      log:'EMITTING RESULT' }
  ];

  scanNum.textContent = '0';
  scanStatus.textContent = STEPS[0].t;
  scanLog.textContent = STEPS[0].log;

  // 重放扫描线 & 闪光
  scanLine.classList.remove('run');
  flashEl.classList.remove('go');
  void scanLine.offsetWidth;
  scanLine.classList.add('run');
  setTimeout(function(){ flashEl.classList.add('go'); }, 1600);

  var i = 0;
  var stepper = setInterval(function(){
    i++;
    if(i >= STEPS.length){ clearInterval(stepper); return; }
    scanStatus.textContent = STEPS[i].t;
    scanLog.textContent = STEPS[i].log;
  }, 340);

  setRing(scanRing, 100, 1650);
  animNum(scanNum, state.thermal, 1650, '', 30);

  setTimeout(function(){
    clearInterval(stepper);
    scanStatus.textContent = '扫描完成';
    scanLog.textContent = 'SCAN COMPLETE';
  }, 1700);

  setTimeout(function(){ showResult(); }, 1900);
}

/* ============================================================
   8. RESULT
   ============================================================ */
var resRing = $('resRing'), resTemp = $('resTemp');
var resName = $('resName'), resEn = $('resEn'), resTagline = $('resTagline');
var resDesc = $('resDesc'), resGlyph = $('resGlyph');
var axisPin = $('axisPin'), axisChips = $('axisChips');
var abilityList = $('abilityList'), kwList = $('kwList');

function showResult(){
  var t = TYPES[state.winner];
  var root = $('s-result');

  root.style.setProperty('--c-a', t.cA);
  root.style.setProperty('--c-b', t.cB);
  root.style.setProperty('--c-t', t.cT);
  root.style.setProperty('--glow-a', t.cB);
  root.style.setProperty('--glow-b', t.cA);

  var stops = document.querySelectorAll('#ringGrad stop');
  if(stops.length === 2){
    stops[0].setAttribute('stop-color', t.cA);
    stops[1].setAttribute('stop-color', t.cB);
  }

  resName.textContent = t.name;
  resEn.textContent = t.en;
  resTagline.textContent = t.tagline;
  resDesc.textContent = t.desc;
  resGlyph.innerHTML = '<svg viewBox="0 0 24 24">' + t.glyph + '</svg>';

  // 温度坐标
  axisChips.innerHTML = '';
  ORDER.forEach(function(k){
    var sp = document.createElement('span');
    sp.textContent = TYPES[k].name.replace('型','');
    if(k === state.winner) sp.className = 'on';
    axisChips.appendChild(sp);
  });

  // 能力解码
  abilityList.innerHTML = '';
  var vals = [];
  ABI.forEach(function(a, i){
    var v = clamp(t.ab[i] + state.jitter[i], 32, 99);
    vals.push(v);
    var row = document.createElement('div');
    row.className = 'ability-row';
    row.innerHTML =
      '<div class="ab-head">' +
        '<span><span class="ab-cn">'+a.cn+'</span> <span class="ab-en">'+a.en+'</span></span>' +
        '<span class="ab-val" data-v="'+v+'">0%</span>' +
      '</div>' +
      '<div class="ab-track"><div class="ab-fill" data-w="'+v+'"></div></div>';
    abilityList.appendChild(row);
  });

  // 关键词
  kwList.innerHTML = '';
  t.kw.forEach(function(k){
    var sp = document.createElement('span');
    sp.className = 'kw';
    sp.textContent = k;
    kwList.appendChild(sp);
  });

  show('s-result');

  // 首帧复位,再触发动画
  resRing.style.transition = 'none';
  resRing.style.strokeDasharray = ringLen(resRing);
  resRing.style.strokeDashoffset = ringLen(resRing);
  resTemp.textContent = '0';
  axisPin.style.transition = 'none';
  axisPin.style.left = '0%';
  abilityList.querySelectorAll('.ab-fill').forEach(function(f){ f.style.width = '0%'; });

  requestAnimationFrame(function(){
    requestAnimationFrame(function(){
      setRing(resRing, state.thermal, 1300);
      animNum(resTemp, state.thermal, 1300, '', 120);

      setTimeout(function(){ axisPin.style.transition = ''; axisPin.style.left = state.thermal + '%'; }, 260);

      abilityList.querySelectorAll('.ab-fill').forEach(function(f, i){
        setTimeout(function(){ f.style.width = f.getAttribute('data-w') + '%'; }, 380 + i*110);
      });
      abilityList.querySelectorAll('.ab-val').forEach(function(el, i){
        animNum(el, parseInt(el.getAttribute('data-v'), 10), 900, '%', 380 + i*110);
      });
    });
  });
}

/* ============================================================
   9. SHARE / RETRY / TOAST
   ============================================================ */
var toastEl = $('toast'), toastTimer = null;
function toast(msg){
  toastEl.textContent = msg;
  toastEl.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(function(){ toastEl.classList.remove('show'); }, 2200);
}

function shareResult(){
  var t = TYPES[state.winner];
  var text = '我的情绪热值是 ' + state.thermal + '°，「' + t.name + '」——' + t.tagline;
  var url = location.href;

  if(navigator.share){
    navigator.share({ title:'情绪温度测试 · 热成像人格扫描', text:text, url:url })
      .catch(function(){ /* 用户取消,不兜底 */ });
    return;
  }
  if(navigator.clipboard && navigator.clipboard.writeText){
    navigator.clipboard.writeText(text + ' ' + url)
      .then(function(){ toast('结果已复制，去粘贴分享吧'); })
      .catch(function(){ toast('长按页面截图即可分享'); });
  } else {
    toast('长按页面截图即可分享');
  }
}

function retry(){
  resetState();
  renderQuestion();
  qBlock.classList.remove('in','out');
  void qBlock.offsetWidth;
  qBlock.classList.add('in');
  show('s-intro');
}

/* ============================================================
   10. BOOT
   ============================================================ */
function startQuiz(){
  resetState();
  renderQuestion();
  qBlock.classList.remove('in','out');
  void qBlock.offsetWidth;
  qBlock.classList.add('in');
  show('s-quiz');
  setTimeout(showKbdHint, 620);
}

$('btnStart').addEventListener('click', startQuiz);

/* 桌面端：柔光跟随指针(只在真正用鼠标时启用) */
var hoveredOpt = null;
qOpts.addEventListener('pointermove', function(e){
  if(e.pointerType && e.pointerType !== 'mouse') return;
  var t = e.target && e.target.closest ? e.target.closest('.opt') : null;
  if(!t || !qOpts.contains(t)) return;
  var g = t.querySelector('.glow');
  if(g){
    var r = t.getBoundingClientRect();
    g.style.left = (e.clientX - r.left) + 'px';
    g.style.top  = (e.clientY - r.top)  + 'px';
  }
  if(hoveredOpt !== t){
    if(hoveredOpt) hoveredOpt.classList.remove('hovering');
    hoveredOpt = t;
    t.classList.add('hovering');
  }
});
qOpts.addEventListener('pointerleave', function(){
  if(hoveredOpt){ hoveredOpt.classList.remove('hovering'); hoveredOpt = null; }
});

/* 键盘作答：1-4 或 A-D */
var KEYMAP = { '1':0, '2':1, '3':2, '4':3, 'a':0, 'b':1, 'c':2, 'd':3 };
document.addEventListener('keydown', function(e){
  if(e.ctrlKey || e.metaKey || e.altKey) return;
  if(!$('s-quiz').classList.contains('active')) return;
  if(state.locked) return;
  var idx = KEYMAP[String(e.key).toLowerCase()];
  if(idx === undefined) return;
  var opts = qOpts.querySelectorAll('.opt');
  if(!opts[idx]) return;
  e.preventDefault();
  pick(idx, opts[idx], null);
});

$('btnShare').addEventListener('click', shareResult);
$('btnRetry').addEventListener('click', retry);

/* 刻度尺：每 4 格加长一条 */
(function buildRulers(){
  var lis = '';
  for(var i=0;i<17;i++) lis += '<i' + (i%4===0 ? ' class="hi"' : '') + '></i>';
  var rs = document.querySelectorAll('.edge-ruler');
  for(var j=0;j<rs.length;j++) rs[j].innerHTML = lis;
})();

/* 热粒子：随机起点/速度/横向漂移，负延迟让它一进场就在空中 */
(function buildDust(){
  var host = $('dust');
  if(!host) return;
  var n = window.innerWidth < 480 ? 18 : 26;
  for(var i=0;i<n;i++){
    var s = document.createElement('i');
    var sz = (1.4 + Math.random()*
