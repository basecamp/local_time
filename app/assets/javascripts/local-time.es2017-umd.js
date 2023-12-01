!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?module.exports=t():"function"==typeof define&&define.amd?define(t):(e="undefined"!=typeof globalThis?globalThis:e||self).LocalTime=t()}(this,(function(){"use strict";var e;e={config:{},run:function(){return this.getController().processElements()},process:function(...e){var t,r,n;for(r=0,n=e.length;r<n;r++)t=e[r],this.getController().processElement(t);return e.length},getController:function(){return null!=this.controller?this.controller:this.controller=new e.Controller}};var t,r,n,a,i,s,o,u,l,c,d,m,h,f,g,p,y,v,S,T,b,M,D,w,E,I,N,A,C,O,$,Y,F,L,W=e;return W.config.useFormat24=!1,W.config.i18n={en:{date:{dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],abbrDayNames:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],abbrMonthNames:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],yesterday:"yesterday",today:"today",tomorrow:"tomorrow",on:"on {date}",formats:{default:"%b %e, %Y",thisYear:"%b %e"}},time:{am:"am",pm:"pm",singular:"a {time}",singularAn:"an {time}",elapsed:"{time} ago",second:"second",seconds:"seconds",minute:"minute",minutes:"minutes",hour:"hour",hours:"hours",formats:{default:"%l:%M%P"}},datetime:{at:"{date} at {time}",formats:{default:"%B %e, %Y at %l:%M%P %Z"}}}},W.config.locale="en",W.config.defaultLocale="en",W.config.timerInterval=6e4,n=!isNaN(Date.parse("2011-01-01T12:00:00-05:00")),W.parseDate=function(e){return e=e.toString(),n||(e=r(e)),new Date(Date.parse(e))},t=/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(Z|[-+]?[\d:]+)$/,r=function(e){var r,n,a,i,s,o,u,l,c,d;if(i=e.match(t))return[r,c,o,n,a,s,l,d]=i,"Z"!==d&&(u=d.replace(":","")),`${c}/${o}/${n} ${a}:${s}:${l} GMT${[u]}`},W.elementMatchesSelector=(a=document.documentElement,i=null!=(s=null!=(o=null!=(u=null!=(l=a.matches)?l:a.matchesSelector)?u:a.webkitMatchesSelector)?o:a.mozMatchesSelector)?s:a.msMatchesSelector,function(e,t){if((null!=e?e.nodeType:void 0)===Node.ELEMENT_NODE)return i.call(e,t)}),({config:c}=W),({i18n:m}=c),W.getI18nValue=function(e="",{locale:t}={locale:c.locale}){var r;return null!=(r=d(m[t],e))?r:t!==c.defaultLocale?W.getI18nValue(e,{locale:c.defaultLocale}):void 0},W.translate=function(e,t={},r){var n,a,i;for(n in i=W.getI18nValue(e,r),t)a=t[n],i=i.replace(`{${n}}`,a);return i},d=function(e,t){var r,n,a,i,s;for(s=e,r=0,a=(i=t.split(".")).length;r<a;r++){if(null==s[n=i[r]])return null;s=s[n]}return s},({getI18nValue:f,translate:M}=W),b="function"==typeof("undefined"!=typeof Intl&&null!==Intl?Intl.DateTimeFormat:void 0),g={"Central European Standard Time":"CET","Central European Summer Time":"CEST","China Standard Time":"CST","Israel Daylight Time":"IDT","Israel Standard Time":"IST","Moscow Standard Time":"MSK","Philippine Standard Time":"PHT","Singapore Standard Time":"SGT","Western Indonesia Time":"WIB"},W.strftime=T=function(e,t){var r,n,a,i,s,o,u;return n=e.getDay(),r=e.getDate(),s=e.getMonth(),u=e.getFullYear(),a=e.getHours(),i=e.getMinutes(),o=e.getSeconds(),t.replace(/%(-?)([%aAbBcdeHIlmMpPSwyYZ])/g,(function(t,l,c){switch(c){case"%":return"%";case"a":return f("date.abbrDayNames")[n];case"A":return f("date.dayNames")[n];case"b":return f("date.abbrMonthNames")[s];case"B":return f("date.monthNames")[s];case"c":return e.toString();case"d":return p(r,l);case"e":return r;case"H":return p(a,l);case"I":return p(T(e,"%l"),l);case"l":return 0===a||12===a?12:(a+12)%12;case"m":return p(s+1,l);case"M":return p(i,l);case"p":return M("time."+(a>11?"pm":"am")).toUpperCase();case"P":return M("time."+(a>11?"pm":"am"));case"S":return p(o,l);case"w":return n;case"y":return p(u%100,l);case"Y":return u;case"Z":return y(e)}}))},p=function(e,t){return"-"===t?e:`0${e}`.slice(-2)},y=function(e){var t,r,n;return(r=h(e))?g[r]:(n=S(e,{allowGMT:!1}))||(n=v(e))?n:(t=S(e,{allowGMT:!0}))?t:""},h=function(e){return Object.keys(g).find((function(t){return b?new Date(e).toLocaleString("en-US",{timeZoneName:"long"}).includes(t):e.toString().includes(t)}))},S=function(e,{allowGMT:t}){var r;if(b&&(r=new Date(e).toLocaleString("en-US",{timeZoneName:"short"}).split(" ").pop(),t||!r.includes("GMT")))return r},v=function(e){var t,r,n,a,i;return(t=null!=(r=(i=e.toString()).match(/\(([\w\s]+)\)$/))?r[1]:void 0)?/\s/.test(t)?t.match(/\b(\w)/g).join(""):t:(t=null!=(n=i.match(/(\w{3,4})\s\d{4}$/))?n[1]:void 0)||(t=null!=(a=i.match(/(UTC[\+\-]\d+)/))?a[1]:void 0)?t:void 0},W.CalendarDate=class{static fromDate(e){return new this(e.getFullYear(),e.getMonth()+1,e.getDate())}static today(){return this.fromDate(new Date)}constructor(e,t,r){this.date=new Date(Date.UTC(e,t-1)),this.date.setUTCDate(r),this.year=this.date.getUTCFullYear(),this.month=this.date.getUTCMonth()+1,this.day=this.date.getUTCDate(),this.value=this.date.getTime()}equals(e){return(null!=e?e.value:void 0)===this.value}is(e){return this.equals(e)}isToday(){return this.is(this.constructor.today())}occursOnSameYearAs(e){return this.year===(null!=e?e.year:void 0)}occursThisYear(){return this.occursOnSameYearAs(this.constructor.today())}daysSince(e){if(e)return(this.date-e.date)/864e5}daysPassed(){return this.constructor.today().daysSince(this)}},({strftime:w,translate:E,getI18nValue:D}=W),W.RelativeTime=class{constructor(e){this.date=e,this.calendarDate=W.CalendarDate.fromDate(this.date)}toString(){var e,t;return(t=this.toTimeElapsedString())?E("time.elapsed",{time:t}):(e=this.toWeekdayString())?(t=this.toTimeString(),E("datetime.at",{date:e,time:t})):E("date.on",{date:this.toDateString()})}toTimeOrDateString(){return this.calendarDate.isToday()?this.toTimeString():this.toDateString()}toTimeElapsedString(){var e,t,r,n,a;return r=(new Date).getTime()-this.date.getTime(),n=Math.round(r/1e3),t=Math.round(n/60),e=Math.round(t/60),r<0?null:n<10?(a=E("time.second"),E("time.singular",{time:a})):n<45?`${n} ${E("time.seconds")}`:n<90?(a=E("time.minute"),E("time.singular",{time:a})):t<45?`${t} ${E("time.minutes")}`:t<90?(a=E("time.hour"),E("time.singularAn",{time:a})):e<24?`${e} ${E("time.hours")}`:""}toWeekdayString(){switch(this.calendarDate.daysPassed()){case 0:return E("date.today");case 1:return E("date.yesterday");case-1:return E("date.tomorrow");case 2:case 3:case 4:case 5:case 6:return w(this.date,"%A");default:return""}}toDateString(){var e;return e=this.calendarDate.occursThisYear()?D("date.formats.thisYear"):D("date.formats.default"),w(this.date,e)}toTimeString(){return w(this.date,D("time.formats.default"))}},({elementMatchesSelector:I}=W),W.PageObserver=class{constructor(e,t){this.processMutations=this.processMutations.bind(this),this.processInsertion=this.processInsertion.bind(this),this.selector=e,this.callback=t}start(){if(!this.started)return this.observeWithMutationObserver()||this.observeWithMutationEvent(),this.started=!0}observeWithMutationObserver(){if("undefined"!=typeof MutationObserver&&null!==MutationObserver)return new MutationObserver(this.processMutations).observe(document.documentElement,{childList:!0,subtree:!0}),!0}observeWithMutationEvent(){return addEventListener("DOMNodeInserted",this.processInsertion,!1),!0}findSignificantElements(e){var t;return t=[],(null!=e?e.nodeType:void 0)===Node.ELEMENT_NODE&&(I(e,this.selector)&&t.push(e),t.push(...e.querySelectorAll(this.selector))),t}processMutations(e){var t,r,n,a,i,s,o,u;for(t=[],r=0,a=e.length;r<a;r++)if("childList"===(s=e[r]).type)for(n=0,i=(u=s.addedNodes).length;n<i;n++)o=u[n],t.push(...this.findSignificantElements(o));return this.notify(t)}processInsertion(e){var t;return t=this.findSignificantElements(e.target),this.notify(t)}notify(e){if(null!=e?e.length:void 0)return"function"==typeof this.callback?this.callback(e):void 0}},({parseDate:C,strftime:O,getI18nValue:A,config:N}=W),W.Controller=function(){var e,t,r;return e="time[data-local]:not([data-localized])",t=function(e){return e.setAttribute("data-localized","")},r=function(e){return new W.RelativeTime(e)},class{constructor(){this.processElements=this.processElements.bind(this),this.pageObserver=new W.PageObserver(e,this.processElements)}start(){if(!this.started)return this.processElements(),this.startTimer(),this.pageObserver.start(),this.started=!0}startTimer(){var e;if(e=N.timerInterval)return null!=this.timer?this.timer:this.timer=setInterval(this.processElements,e)}processElements(t=document.querySelectorAll(e)){var r,n,a;for(n=0,a=t.length;n<a;n++)r=t[n],this.processElement(r);return t.length}processElement(e){var n,a,i,s,o;if(n=e.getAttribute("datetime"),i=e.getAttribute("data-local"),a=N.useFormat24&&e.getAttribute("data-format24")||e.getAttribute("data-format"),s=C(n),!isNaN(s))return e.hasAttribute("title")||(o=O(s,A("datetime.formats.default")),e.setAttribute("title",o)),e.textContent=function(){switch(i){case"time":return t(e),O(s,a);case"date":return t(e),r(s).toDateString();case"time-ago":return r(s).toString();case"time-or-date":return r(s).toTimeOrDateString();case"weekday":return r(s).toWeekdayString();case"weekday-or-date":return r(s).toWeekdayString()||r(s).toDateString()}}()}}}.call(window),L=!1,$=function(){return document.attachEvent?"complete"===document.readyState:"loading"!==document.readyState},Y=function(e){var t;return null!=(t="function"==typeof requestAnimationFrame?requestAnimationFrame(e):void 0)?t:setTimeout(e,17)},F=function(){return W.getController().start()},W.start=function(){if(!L)return L=!0,"undefined"!=typeof MutationObserver&&null!==MutationObserver||$()?F():Y(F)},window.LocalTime===W&&W.start(),W}));
