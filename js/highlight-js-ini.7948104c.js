/*!
 * This source file is part of the Swift.org open source project
 * 
 * Copyright (c) 2021 Apple Inc. and the Swift project authors
 * Licensed under Apache License v2.0 with Runtime Library Exception
 * 
 * See https://swift.org/LICENSE.txt for license information
 * See https://swift.org/CONTRIBUTORS.txt for Swift project authors
 */
(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["highlight-js-ini"],{"2a93":function(e,n){function a(e){const n=e.regex,a={className:"number",relevance:0,variants:[{begin:/([+-]+)?[\d]+_[\d_]+/},{begin:e.NUMBER_RE}]},s=e.COMMENT();s.variants=[{begin:/;/,end:/$/},{begin:/#/,end:/$/}];const i={className:"variable",variants:[{begin:/\$[\w\d"][\w\d_]*/},{begin:/\$\{(.*?)\}/}]},t={className:"literal",begin:/\bon|off|true|false|yes|no\b/},c={className:"string",contains:[e.BACKSLASH_ESCAPE],variants:[{begin:"'''",end:"'''",relevance:10},{begin:'"""',end:'"""',relevance:10},{begin:'"',end:'"'},{begin:"'",end:"'"}]},l={begin:/\[/,end:/\]/,contains:[s,t,i,c,a,"self"],relevance:0},o=/[A-Za-z0-9_-]+/,b=/"(\\"|[^"])*"/,r=/'[^']*'/,g=n.either(o,b,r),d=n.concat(g,"(\\s*\\.\\s*",g,")*",n.lookahead(/\s*=\s*[^#\s]/));return{name:"TOML, also INI",aliases:["toml"],case_insensitive:!0,illegal:/\S/,contains:[s,{className:"section",begin:/\[+/,end:/\]+/},{begin:d,className:"attr",starts:{end:/$/,contains:[s,l,t,i,c,a]}}]}}e.exports=a}}]);