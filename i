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
  --hot:#FF6B2C;
  --amber:#FFB020;
  --ink:#180A03;
  --ease:cubic-bezier(.22,1,.36,1);
  --ramp:linear-gradient(90deg,#3B5BFF 0%,#5AA8FF 18%,#8FE3E0 34%,#FFD166 54%,#FF9A2E 76%,#FF4D2C 100%);
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
.blob{position:absolute;border-radius:50%;filter:blur(70px);opacity:.5;will-change:transform;}
.blob-cold{width:70vw;height:70vw;max-width:520px;max-height:520px;top:-22%;left:-28%;
  background:radial-gradient(circle,rgba(59,91,255,.55),rgba(59,91,255,0) 66%);
  animation:drift1 22s ease-in-out infinite;}
.blob-hot{width:78vw;height:78vw;max-width:600px;max-height:600px;bottom:-26%;right:-32%;
  background:radial-gradient(circle,rgba(255,107,44,.48),rgba(255,107,44,0) 66%);
  animation:drift2 26s ease-in-out infinite;}
@keyframes drift1{0%,100%{transform:translate3d(0,0,0) scale(1)}50%{transform:translate3d(6vw,4vh,0) scale(1.12)}}
@keyframes drift2{0%,100%{transform:translate3d(0,0,0) scale(1.06)}50%{transform:translate3d(-7vw,-5vh,0) scale(1)}}
.grid{position:absolute;inset:-2px;opacity:.5;
  background-image:linear-gradient(rgba(255,255,255,.028) 1px,transparent 1px),
    linear-gradient(90deg,rgba(255,255,255,.028) 1px,transparent 1px);
  background-size:46px 46px;
  -webkit-mask-image:radial-gradient(90% 70% at 50% 45%,#000 0%,transparent 78%);
  mask-image:radial-gradient(90% 70% at 50% 45%,#000 0%,transparent 78%);}
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
.hud .dot{display:inline-block;width:5px;height:5px;border-radius:50%;background:var(--hot);
  box-shadow:0 0 8px 1px rgba(255,107,44,.8);margin-right:7px;vertical-align:middle;
  animation:blip 1.8s ease-in-out infinite;}
@keyframes blip{0%,100%{opacity:1}50%{opacity:.25}}
.hud-l{display:flex;align-items:center;}

/* ---------- intro ---------- */
.intro-orb-wrap{flex:1;display:flex;align-items:center;justify-content:center;padding:20px 0 8px;min-height:190px;}
.orb{position:relative;width:min(58vw,236px);aspect-ratio:1;display:grid;place-items:center;}
.orb::before{content:"";position:absolute;inset:-30%;border-radius:50%;
  background:radial-gradient(circle,rgba(255,107,44,.24),rgba(255,107,44,0) 62%);filter:blur(26px);}
.orb::after{content:"";position:absolute;inset:-14%;border-radius:50%;
  background:radial-gradient(circle,rgba(59,91,255,.2),rgba(59,91,255,0) 60%);filter:blur(30px);}
.orb-sweep{position:absolute;inset:0;border-radius:50%;
  background:conic-gradient(from 0deg,rgba(255,150,80,0) 0deg,rgba(255,150,80,0) 292deg,
    rgba(255,170,100,.05) 318deg,rgba(255,190,120,.14) 342deg,rgba(255,215,160,.34) 356deg,rgba(255,246,225,.7) 360deg);
  -webkit-mask:radial-gradient(circle,transparent 0 27%,#000 32%);
  mask:radial-gradient(circle,transparent 0 27%,#000 32%);
  animation:sweep 4.4s linear infinite;}
@keyframes sweep{to{transform:rotate(360deg)}}
.orb-core{position:absolute;width:34%;aspect-ratio:1;border-radius:50%;
  background:radial-gradient(circle at 50% 46%,#FFF6DE,#FFC53D 30%,#FF6B2C 58%,rgba(255,107,44,0) 76%);
  filter:blur(9px);animation:corePulse 3.4s ease-in-out infinite;}
@keyframes corePulse{0%,100%{transform:scale(.88);opacity:.7}50%{transform:scale(1.08);opacity:1}}
.orb-svg{position:absolute;inset:0;width:100%;height:100%;overflow:visible;}
.ring-tick{fill:none;stroke:rgba(255,255,255,.135);stroke-width:1;stroke-dasharray:1.6 7.4;}
.ring-thin{fill:none;stroke:rgba(255,255,255,.09);stroke-width:1;}
.ring-warm{fill:none;stroke:rgba(255,150,70,.3);stroke-width:1;stroke-dasharray:34 14;
  transform-box:fill-box;transform-origin:center;animation:spin 26s linear infinite;}
@keyframes spin{to{transform:rotate(360deg)}}
.tick-lg{stroke:rgba(255,255,255,.38);stroke-width:1.5;stroke-linecap:round;}

.intro-txt{text-align:center;padding-bottom:6px;}
.intro-kicker{font-size:10px;letter-spacing:.34em;color:var(--amber);text-transform:uppercase;margin-bottom:14px;opacity:.85;}
.intro-title{font-size:clamp(30px,8.6vw,38px);font-weight:700;letter-spacing:.02em;line-height:1.18;
  background:linear-gradient(112deg,#FFF6DE 0%,#FFD166 30%,#FF8A3D 62%,#FF5A2C 100%);
  -webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent;}
.intro-sub{margin-top:12px;font-size:10px;letter-spacing:.3em;color:var(--t2);text-transform:uppercase;}
.intro-desc{margin:20px auto 0;max-width:330px;font-size:13.5px;line-height:1.9;color:var(--t1);}
.intro-meta{display:flex;justify-content:center;gap:10px;margin:24px 0 22px;flex-wrap:wrap;}
.chip{display:flex;align-items:center;gap:6px;padding:7px 13px;border-radius:999px;
  border:1px solid var(--line);background:rgba(255,255,255,.025);font-size:11px;color:var(--t1);}
.chip b{font-family:var(--mono);font-weight:500;color:var(--amber);font-size:12px;}

/* ---------- buttons ---------- */
.btn{position:relative;width:100%;height:54px;border-radius:15px;font-size:15px;font-weight:600;
  letter-spacing:.04em;display:flex;align-items:center;justify-content:center;gap:9px;
  transition:transform .16s var(--ease),box-shadow .3s var(--ease);overflow:hidden;}
.btn:active{transform:scale(.972);}
.btn-primary{color:var(--ink);background:linear-gradient(103deg,#FFD166 0%,#FF9A2E 44%,#FF6B2C 100%);
  box-shadow:0 10px 30px -8px rgba(255,122,44,.6),inset 0 1px 0 rgba(255,255,255,.5);}
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
.prog-meta .cnt b{color:var(--t0);font-weight:600;font-size:13px;}
.prog-track{position:relative;height:3px;border-radius:99px;background:rgba(255,255,255,.07);}
.prog-fill{position:absolute;left:0;top:0;bottom:0;width:0%;border-radius:99px;
  background:var(--ramp);background-size:440px 100%;transition:width .5s var(--ease);}
.prog-head{position:absolute;top:50%;left:0%;width:9px;height:9px;border-radius:50%;
  transform:translate(-50%,-50%);background:#FFF3D6;
  box-shadow:0 0 10px 3px rgba(255,140,60,.85),0 0 22px 8px rgba(255,107,44,.4);
  transition:left .5s var(--ease);}

.q-zone{flex:1;display:flex;flex-direction:column;justify-content:center;padding:26px 0 10px;}
.q-block{will-change:transform,opacity;}
.q-block.out{animation:qOut .22s var(--ease) forwards;}
.q-block.in{animation:qIn .42s var(--ease) both;}
@keyframes qOut{to{opacity:0;transform:translate3d(-22px,0,0);}}
@keyframes qIn{from{opacity:0;transform:translate3d(26px,0,0);}to{opacity:1;transform:none;}}
.q-idx{display:flex;align-items:center;gap:10px;font-size:10px;letter-spacing:.22em;color:var(--amber);margin-bottom:14px;}
.q-idx .bar{width:22px;height:1px;background:linear-gradient(90deg,var(--hot),transparent);}
.q-text{font-size:clamp(20px,5.6vw,24px);font-weight:700;line-height:1.5;letter-spacing:.01em;
  color:var(--t0);margin-bottom:26px;}
.opts{display:flex;flex-direction:column;gap:11px;}
.opt{position:relative;display:flex;align-items:center;gap:13px;width:100%;text-align:left;
  padding:15px 15px 15px 14px;border-radius:14px;border:1px solid var(--line);
  background:linear-gradient(180deg,rgba(255,255,255,.038),rgba(255,255,255,.014));overflow:hidden;
  transition:border-color .22s var(--ease),background .22s var(--ease),transform .18s var(--ease);}
.opt::before{content:"";position:absolute;left:0;top:0;bottom:0;width:0%;
  background:linear-gradient(90deg,rgba(255,107,44,.28),rgba(255,177,32,.06));
  transition:width .55s var(--ease);}
.opt:active{transform:scale(.985);}
.opt .key{position:relative;flex:0 0 auto;width:27px;height:27px;border-radius:8px;display:grid;
  place-items:center;font-family:var(--mono);font-size:12px;font-weight:600;
  border:1px solid var(--line-2);color:var(--t1);transition:all .25s var(--ease);}
.opt .txt{position:relative;flex:1;font-size:14.5px;line-height:1.55;color:var(--t1);transition:color .25s;}
.opt .glow{position:absolute;right:-30px;top:50%;width:120px;height:120px;
  transform:translateY(-50%) scale(.4);opacity:0;border-radius:50%;
  background:radial-gradient(circle,rgba(255,140,60,.5),transparent 68%);
  filter:blur(16px);transition:opacity .35s,transform .45s var(--ease);pointer-events:none;}
.opt.picked{border-color:rgba(255,150,70,.55);background:rgba(255,122,44,.075);}
.opt.picked::before{width:100%;}
.opt.picked .key{border-color:transparent;color:var(--ink);
  background:linear-gradient(135deg,#FFD166,#FF7A2F);box-shadow:0 0 14px rgba(255,140,60,.6);}
.opt.picked .txt{color:var(--t0);}
.opt.picked .glow{opacity:1;transform:translateY(-50%) scale(1);}
@media(hover:hover){
  .opt:hover{border-color:var(--line-2);background:rgba(255,255,255,.055);}
  .opt:hover .txt{color:var(--t0);}
}

/* ---------- scan ---------- */
#s-scan .pad{justify-content:center;align-items:center;}
.scan-wrap{position:relative;display:flex;flex-direction:column;align-items:center;gap:30px;}
.scan-line{position:absolute;left:-50vw;right:-50vw;height:1px;top:0;opacity:0;
  background:linear-gradient(90deg,transparent,rgba(255,170,90,.85),transparent);
  box-shadow:0 0 18px 3px rgba(255,140,60,.5);}
.scan-line.run{opacity:1;animation:scanDown 1.9s cubic-bezier(.4,0,.6,1) forwards;}
@keyframes scanDown{from{top:-14%}to{top:112%}}
.scan-ring-box{position:relative;width:min(62vw,250px);aspect-ratio:1;display:grid;place-items:center;}
.scan-ring-box::before{content:"";position:absolute;inset:-24%;border-radius:50%;
  background:radial-gradient(circle,rgba(255,140,60,.22),transparent 62%);
  filter:blur(26px);animation:corePulse 2.6s ease-in-out infinite;}
.scan-ring{width:100%;height:100%;transform:rotate(-90deg);}
.scan-ring circle{fill:none;stroke-width:3;stroke-linecap:round;}
.sr-bg{stroke:rgba(255,255,255,.08);}
.sr-fg{stroke:url(#scanGrad);filter:drop-shadow(0 0 7px rgba(255,140,60,.75));}
.scan-tick{position:absolute;inset:-6%;border-radius:50%;border:1px dashed rgba(255,255,255,.13);
  animation:spin 30s linear infinite reverse;}
.scan-center{position:absolute;display:flex;flex-direction:column;align-items:center;}
.scan-num{font-family:var(--mono);font-size:clamp(38px,12vw,52px);font-weight:600;line-height:1;
  letter-spacing:-.02em;color:#FFF3D6;text-shadow:0 0 26px rgba(255,150,70,.75);}
.scan-num i{font-size:.44em;font-style:normal;color:var(--amber);margin-left:2px;vertical-align:top;}
.scan-unit{margin-top:9px;font-size:9px;letter-spacing:.26em;color:var(--t2);text-transform:uppercase;}
.scan-status{font-size:12px;letter-spacing:.14em;color:var(--t1);height:20px;
  display:flex;align-items:center;gap:8px;}
.scan-status .dot{width:5px;height:5px;border-radius:50%;background:var(--amber);
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
  <div class="bg">
    <div class="blob blob-cold"></div>
    <div class="blob blob-hot"></div>
    <div class="grid"></div>
    <div class="scanlines"></div>
    <div class="noise"></div>
    <div class="vign"></div>
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
              <circle class="ring-warm" cx="130" cy="130" r="74"/>
              <circle class="ring-thin" cx="130" cy="130" r="46"/>
              <line class="tick-lg" x1="130" y1="4" x2="130" y2="22"/>
              <line class="tick-lg" x1="130" y1="238" x2="130" y2="256"/>
              <line class="tick-lg" x1="4" y1="130" x2="22" y2="130"/>
              <line class="tick-lg" x1="238" y1="130" x2="256" y2="130"/>
              <line x1="130" y1="52" x2="130" y2="86" stroke="rgba(255,150,70,.35)" stroke-width="1"/>
              <line x1="130" y1="174" x2="130" y2="208" stroke="rgba(255,150,70,.35)" stroke-width="1"/>
              <line x1="52" y1="130" x2="86" y2="130" stroke="rgba(255,150,70,.35)" stroke-width="1"/>
              <line x1="174" y1="130" x2="208" y2="130" stroke="rgba(255,150,70,.35)" stroke-width="1"/>
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
          </div>
        </div>

        <div class="q-zone">
          <div class="q-block" id="qBlock">
            <div class="q-idx"><span class="bar"></span><span id="qIdx">QUESTION 01</span></div>
            <h2 class="q-text" id="qText"></h2>
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
                  <stop offset="0%" stop-color="#3B5BFF"/>
                  <stop offset="40%" stop-color="#8FE3E0"/>
                  <stop offset="72%" stop-color="#FFD166"/>
                  <stop offset="100%" stop-color="#FF4D2C"/>
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
}

/* ============================================================
   4. SCREENS
   ============================================================ */
var screens = ['s-intro','s-quiz','s-scan','s-result'];
function show(id){
  screens.forEach(function(s){
    $(s).classList.toggle('active', s===id);
  });
  var el = $(id);
  if(el) el.scrollTop = 0;
}

/* ============================================================
   5. QUIZ
   ============================================================ */
var qBlock = $('qBlock'), qText = $('qText'), qOpts = $('qOpts'), qIdx = $('qIdx');
var qNow = $('qNow'), progFill = $('progFill'), progHead = $('progHead');

function renderQuestion(){
  var q = QUESTIONS[state.qi];
  qIdx.textContent = 'QUESTION ' + pad2(state.qi+1);
  qNow.textContent = pad2(state.qi+1);
  qText.textContent = q.q;

  var pct = (state.qi+1)/QUESTIONS.length*100;
  progFill.style.width = pct + '%';
  progHead.style.left = pct + '%';

  qOpts.innerHTML = '';
  q.o.forEach(function(op, i){
    var b = document.createElement('button');
    b.type = 'button';
    b.className = 'opt';
    b.innerHTML =
      '<span class="key">'+LETTERS[i]+'</span>' +
      '<span class="txt">'+op.x+'</span>' +
      '<span class="glow"></span>';
    b.addEventListener('click', function(){ pick(i, b); });
    qOpts.appendChild(b);
  });
}

function pick(i, el){
  if(state.locked) return;
  state.locked = true;
  el.classList.add('picked');

  var sib = qOpts.querySelectorAll('.opt');
  for(var k=0;k<sib.length;k++) sib[k].style.pointerEvents = 'none';

  state.answers[state.qi] = i;

  setTimeout(function(){
    state.locked = false;
    if(state.qi >= QUESTIONS.length-1){
      runScan();
    } else {
      nextQuestion();
    }
  }, 320);
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
  progFill.style.width = '0%';
  progHead.style.left = '0%';
  show('s-intro');
}

/* ============================================================
   10. BOOT
   ============================================================ */
$('btnStart').addEventListener('click', function(){
  resetState();
  renderQuestion();
  qBlock.classList.remove('in','out');
  void qBlock.offsetWidth;
  qBlock.classList.add('in');
  show('s-quiz');
});

$('btnShare').addEventListener('click', shareResult);
$('btnRetry').addEventListener('click', retry);

// 预置第一题(即使未进入答题,内容也已就绪)
renderQuestion();
qBlock.classList.remove('in');

})();
</script>
</body>
</html>
