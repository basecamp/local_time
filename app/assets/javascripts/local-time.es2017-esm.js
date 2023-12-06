var e;e={config:{},run:function(){return this.getController().processElements()},process:function(...e){var t,r,n;for(r=0,n=e.length;r<n;r++)t=e[r],this.getController().processElement(t);return e.length},getController:function(){return null!=this.controller?this.controller:this.controller=new e.Controller}};var t,r,n,s,a,i,o,l,u,d,c,m,h,g,f,v,b,p,S,y,T,M,D,E,w,O,A,C,N,I,k,$,F,L,U,Y,P=e;P.config.useFormat24=!1,P.config.i18n={en:{date:{dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],abbrDayNames:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],monthNames:["January","February","March","April","May","June","July","August","September","October","November","December"],abbrMonthNames:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],yesterday:"yesterday",today:"today",tomorrow:"tomorrow",on:"on {date}",formats:{default:"%b %e, %Y",thisYear:"%b %e"}},time:{am:"am",pm:"pm",singular:"a {time}",singularAn:"an {time}",elapsed:"{time} ago",second:"second",seconds:"seconds",minute:"minute",minutes:"minutes",hour:"hour",hours:"hours",formats:{default:"%l:%M%P",default_24h:"%H:%M"}},datetime:{at:"{date} at {time}",formats:{default:"%B %e, %Y at %l:%M%P %Z",default_24h:"%B %e, %Y at %H:%M %Z"}}}},P.config.locale="en",P.config.defaultLocale="en",P.config.timerInterval=6e4,n=!isNaN(Date.parse("2011-01-01T12:00:00-05:00")),P.parseDate=function(e){return e=e.toString(),n||(e=r(e)),new Date(Date.parse(e))},t=/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(Z|[-+]?[\d:]+)$/,r=function(e){var r,n,s,a,i,o,l,u,d,c;if(a=e.match(t))return[r,d,o,n,s,i,u,c]=a,"Z"!==c&&(l=c.replace(":","")),`${d}/${o}/${n} ${s}:${i}:${u} GMT${[l]}`},P.elementMatchesSelector=(s=document.documentElement,a=null!=(i=null!=(o=null!=(l=null!=(u=s.matches)?u:s.matchesSelector)?l:s.webkitMatchesSelector)?o:s.mozMatchesSelector)?i:s.msMatchesSelector,function(e,t){if((null!=e?e.nodeType:void 0)===Node.ELEMENT_NODE)return a.call(e,t)}),({config:d}=P),({i18n:m}=d),P.getI18nValue=function(e="",{locale:t}={locale:d.locale}){var r;return null!=(r=c(m[t],e))?r:t!==d.defaultLocale?P.getI18nValue(e,{locale:d.defaultLocale}):void 0},P.translate=function(e,t={},r){var n,s,a;for(n in a=P.getI18nValue(e,r),t)s=t[n],a=a.replace(`{${n}}`,s);return a},c=function(e,t){var r,n,s,a,i;for(i=e,r=0,s=(a=t.split(".")).length;r<s;r++){if(null==i[n=a[r]])return null;i=i[n]}return i},({getI18nValue:g,translate:M}=P),T="function"==typeof("undefined"!=typeof Intl&&null!==Intl?Intl.DateTimeFormat:void 0),f={"Central European Standard Time":"CET","Central European Summer Time":"CEST","China Standard Time":"CST","Israel Daylight Time":"IDT","Israel Standard Time":"IST","Moscow Standard Time":"MSK","Philippine Standard Time":"PHT","Singapore Standard Time":"SGT","Western Indonesia Time":"WIB"},P.knownEdgeCaseTimeZones=f,P.strftime=y=function(e,t){var r,n,s,a,i,o,l;return n=e.getDay(),r=e.getDate(),i=e.getMonth(),l=e.getFullYear(),s=e.getHours(),a=e.getMinutes(),o=e.getSeconds(),t.replace(/%(-?)([%aAbBcdeHIlmMpPSwyYZ])/g,(function(t,u,d){switch(d){case"%":return"%";case"a":return g("date.abbrDayNames")[n];case"A":return g("date.dayNames")[n];case"b":return g("date.abbrMonthNames")[i];case"B":return g("date.monthNames")[i];case"c":return e.toString();case"d":return v(r,u);case"e":return r;case"H":return v(s,u);case"I":return v(y(e,"%l"),u);case"l":return 0===s||12===s?12:(s+12)%12;case"m":return v(i+1,u);case"M":return v(a,u);case"p":return M("time."+(s>11?"pm":"am")).toUpperCase();case"P":return M("time."+(s>11?"pm":"am"));case"S":return v(o,u);case"w":return n;case"y":return v(l%100,u);case"Y":return l;case"Z":return b(e)}}))},v=function(e,t){return"-"===t?e:`0${e}`.slice(-2)},b=function(e){var t,r,n;return(r=h(e))?f[r]:(n=S(e,{allowGMT:!1}))||(n=p(e))?n:(t=S(e,{allowGMT:!0}))?t:""},h=function(e){return Object.keys(f).find((function(t){return T?new Date(e).toLocaleString("en-US",{timeZoneName:"long"}).includes(t):e.toString().includes(t)}))},S=function(e,{allowGMT:t}){var r;if(T&&(r=new Date(e).toLocaleString("en-US",{timeZoneName:"short"}).split(" ").pop(),t||!r.includes("GMT")))return r},p=function(e){var t,r,n,s,a;return(t=null!=(r=(a=e.toString()).match(/\(([\w\s]+)\)$/))?r[1]:void 0)?/\s/.test(t)?t.match(/\b(\w)/g).join(""):t:(t=null!=(n=a.match(/(\w{3,4})\s\d{4}$/))?n[1]:void 0)||(t=null!=(s=a.match(/(UTC[\+\-]\d+)/))?s[1]:void 0)?t:void 0},P.CalendarDate=class{static fromDate(e){return new this(e.getFullYear(),e.getMonth()+1,e.getDate())}static today(){return this.fromDate(new Date)}constructor(e,t,r){this.date=new Date(Date.UTC(e,t-1)),this.date.setUTCDate(r),this.year=this.date.getUTCFullYear(),this.month=this.date.getUTCMonth()+1,this.day=this.date.getUTCDate(),this.value=this.date.getTime()}equals(e){return(null!=e?e.value:void 0)===this.value}is(e){return this.equals(e)}isToday(){return this.is(this.constructor.today())}occursOnSameYearAs(e){return this.year===(null!=e?e.year:void 0)}occursThisYear(){return this.occursOnSameYearAs(this.constructor.today())}daysSince(e){if(e)return(this.date-e.date)/864e5}daysPassed(){return this.constructor.today().daysSince(this)}},({strftime:w,translate:O,getI18nValue:E,config:D}=P),P.RelativeTime=class{constructor(e){this.date=e,this.calendarDate=P.CalendarDate.fromDate(this.date)}toString(){var e,t;return(t=this.toTimeElapsedString())?O("time.elapsed",{time:t}):(e=this.toWeekdayString())?(t=this.toTimeString(),O("datetime.at",{date:e,time:t})):O("date.on",{date:this.toDateString()})}toTimeOrDateString(){return this.calendarDate.isToday()?this.toTimeString():this.toDateString()}toTimeElapsedString(){var e,t,r,n,s;return r=(new Date).getTime()-this.date.getTime(),n=Math.round(r/1e3),t=Math.round(n/60),e=Math.round(t/60),r<0?null:n<10?(s=O("time.second"),O("time.singular",{time:s})):n<45?`${n} ${O("time.seconds")}`:n<90?(s=O("time.minute"),O("time.singular",{time:s})):t<45?`${t} ${O("time.minutes")}`:t<90?(s=O("time.hour"),O("time.singularAn",{time:s})):e<24?`${e} ${O("time.hours")}`:""}toWeekdayString(){switch(this.calendarDate.daysPassed()){case 0:return O("date.today");case 1:return O("date.yesterday");case-1:return O("date.tomorrow");case 2:case 3:case 4:case 5:case 6:return w(this.date,"%A");default:return""}}toDateString(){var e;return e=this.calendarDate.occursThisYear()?E("date.formats.thisYear"):E("date.formats.default"),w(this.date,e)}toTimeString(){var e;return e=D.useFormat24?"default_24h":"default",w(this.date,E(`time.formats.${e}`))}},({elementMatchesSelector:A}=P),P.PageObserver=class{constructor({elementAddedSelector:e,elementAddedCallback:t,elementRemovedSelector:r,elementRemovedCallback:n}){this.processMutations=this.processMutations.bind(this),this.processInsertion=this.processInsertion.bind(this),this.elementAddedSelector=e,this.elementAddedCallback=t,this.elementRemovedSelector=r,this.elementRemovedCallback=n}start(){if(!this.started)return this.observe(),this.started=!0}observe(){return new MutationObserver(this.processMutations).observe(document.documentElement,{childList:!0,subtree:!0})}processMutations(e){var t,r,n,s,a,i,o,l,u,d,c;for(t=[],r=0,a=e.length;r<a;r++)if("childList"===(l=e[r]).type){for(n=0,i=(d=l.addedNodes).length;n<i;n++)u=d[n],t.push(...this.findSignificantElements(u));for(s=0,o=(c=l.removedNodes).length;s<o;s++)u=c[s],A(u,this.elementRemovedSelector)&&this.elementRemovedCallback(u)}return this.notify(t)}findSignificantElements(e){var t;return t=[],(null!=e?e.nodeType:void 0)===Node.ELEMENT_NODE&&(A(e,this.elementAddedSelector)&&t.push(e),t.push(...e.querySelectorAll(this.elementAddedSelector))),t}processInsertion(e){var t;return t=this.findSignificantElements(e.target),this.notify(t)}notify(e){if(null!=e?e.length:void 0)return"function"==typeof this.elementAddedCallback?this.elementAddedCallback(e):void 0}},({elementMatchesSelector:C}=P),P.ElementObservations=function(){var e;return e=["datetime","data-local","data-format","data-format24"],class{constructor(e,t){this.include=this.include.bind(this),this.disregard=this.disregard.bind(this),this.startObserving=this.startObserving.bind(this),this.registerObserver=this.registerObserver.bind(this),this.processMutations=this.processMutations.bind(this),this.processLingeringElement=this.processLingeringElement.bind(this),this.incrementUpdates=this.incrementUpdates.bind(this),this.selector=e,this.callback=t,this.elements=new Map}include(e){var t;if(!this.elements.get(e))return t=this.startObserving(e),this.registerObserver(e,t)}disregard(e){var t,r;if(t=null!=(r=this.elements.get(e))?r.observer:void 0)return t.disconnect(),this.elements.delete(e)}startObserving(t){var r;return(r=new MutationObserver(this.processMutations)).observe(t,{characterData:!0,subtree:!0,attributes:!0,attributeFilter:e}),r}registerObserver(e,t){return this.elements.set(e,{observer:t,updates:-1}),this.incrementUpdates(e)}processMutations(e){var t,r,n,s,a;for(s=[],r=0,n=e.length;r<n;r++){if(t=(a=e[r].target).nodeType===Node.TEXT_NODE?a.parentNode:a,C(t,this.selector)){this.processLingeringElement(t);break}s.push(void 0)}return s}processLingeringElement(e){return this.incrementUpdates(e),this.callback(e)}incrementUpdates(e){return this.elements.get(e).updates++,e.setAttribute("data-updates",this.elements.get(e).updates)}size(){return this.elements.size}}}.call(window),({parseDate:k,strftime:$,getI18nValue:I,config:N}=P),P.Controller=function(){var e,t,r,n;return e=`${t="time[data-local]"}:not([data-localized])`,r=function(e){return e.setAttribute("data-localized","")},n=function(e){return new P.RelativeTime(e)},class{constructor(){this.processElements=this.processElements.bind(this),this.processElement=this.processElement.bind(this),this.connectObserver=this.connectObserver.bind(this),this.disconnectObserver=this.disconnectObserver.bind(this),this.observations=new P.ElementObservations(t,this.processElement),this.pageObserver=new P.PageObserver({elementAddedSelector:e,elementAddedCallback:this.processElements,elementRemovedSelector:t,elementRemovedCallback:this.disconnectObserver})}start(){if(!this.started)return this.processElements(),this.startTimer(),this.pageObserver.start(),this.started=!0}startTimer(){var e;if(e=N.timerInterval)return null!=this.timer?this.timer:this.timer=setInterval(this.processElements,e)}processElements(t=document.querySelectorAll(e)){var r,n,s;for(n=0,s=t.length;n<s;n++)r=t[n],this.processElement(r);return t.length}processElement(e){var t,s,a,i,o,l;if(t=e.getAttribute("datetime"),a=e.getAttribute("data-local"),s=N.useFormat24&&e.getAttribute("data-format24")||e.getAttribute("data-format"),i=k(t),!isNaN(i))return e.hasAttribute("title")||(l=N.useFormat24?"default_24h":"default",o=$(i,I(`datetime.formats.${l}`)),e.setAttribute("title",o)),e.textContent=function(){switch(a){case"time":return r(e),$(i,s);case"date":return r(e),n(i).toDateString();case"time-ago":return n(i).toString();case"time-or-date":return n(i).toTimeOrDateString();case"weekday":return n(i).toWeekdayString();case"weekday-or-date":return n(i).toWeekdayString()||n(i).toDateString()}}(),this.connectObserver(e)}connectObserver(e){return this.observations.include(e)}disconnectObserver(e){return this.observations.disregard(e)}}}.call(window),Y=!1,F=function(){return document.attachEvent?"complete"===document.readyState:"loading"!==document.readyState},L=function(e){var t;return null!=(t="function"==typeof requestAnimationFrame?requestAnimationFrame(e):void 0)?t:setTimeout(e,17)},U=function(){return P.getController().start()},P.start=function(){return Y?P.run():(Y=!0,"undefined"!=typeof MutationObserver&&null!==MutationObserver||F()?U():L(U))},window.LocalTime===P&&P.start();export{P as default};
