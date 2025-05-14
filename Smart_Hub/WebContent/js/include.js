const nav=document.querySelector('.header')
fetch('header.html')
.then(res=>res.text())
.then(data=>{
    nav.innerHTML=data})