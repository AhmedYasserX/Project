var alert = require("alert");
const { checkPrime } = require("crypto");
const { resolveSoa } = require("dns");
const e = require('express');
const { json } = require("express");
var express = require('express');
//var session = require('express-session');
var path = require('path');
const { nextTick } = require("process");
var app = express();
var MongoClient = require('mongodb').MongoClient;
const cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var loggedin = false;
app.use(bodyParser.json());
app.use(cookieParser());

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));
/*app.use(session({
secret:process.env.SESSION_SECRET,
resave: false,
saveUninitialized: true,
cookie:{secure:true}
}));*/


app.get('/' , function(req,res) {
     res.render('login')
});

app.post('/',function(req,res){
  var u = req.body.username;
  var p = req.body.password;
MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
  if(err) throw err;
  var check = false;
  var index;
  var db = client.db('myDB');
  db.collection("myCollection").find({}).toArray(function(err,myCollection){
    if(err) throw err;
    if(u =='' || p =='') {
      alert("Enter a username and a Password");
    }
    else {
      for(let i =0 ; i < myCollection.length; i++) {
        if(myCollection[i].Username==u) {
          check=true;
          index=i;
        }
    }
    if(check){
      if(myCollection[index].Password==p) {
        loggedin=true;
        res.cookie('loggedUser',u);
        res.render('home');
      }
      else{
        alert("Username or password is incorrect");
      }
    }
    else {
      alert("Username or password is incorrect");
    }
  }

})
})
});

app.get('/registration',function(req,res){
  res.render('registration')
  });

app.post('/registration',async function(req,res){
  var u = req.body.username
  var p = req.body.password
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var check = false;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
     if(err) throw err;
     if(u =='' || p =='') {
      alert("Enter a username and a Password");
    }
     else {
      for(let i =0 ; i < myCollection.length; i++) {
      if(myCollection[i].Username==u) {
        check=true;
      }
      }
      if(check){
        alert("Username already taken");
      }
      else {
      alert("Registration was successful");
      var goto = [];
      db.collection('myCollection').insertOne({Username:u,Password:p,list:goto});
      res.redirect('/');
      res.render('login');
      
    }
    
    }
  }) 
})
});

//hiking
app.get('/hiking',function(req,res){
      if(loggedin) {
        res.render('hiking')
      }
      else {
        res.redirect('/')
      }
    });

//inca

app.get('/inca',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  if(loggedin) {
    res.render('inca')
  }
  else {
    res.redirect('/')
  }
})

app.post('/inca',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
      if(err) throw err;
    var check = false;
    for(let i = 0; i<myCollection.length;i++) {
      if(loggedUser==myCollection[i].Username) {
        var goto=myCollection[i].list;
        for(let y = 0 ; y<goto.length;y++) {
          if(goto[y]=="Inca") {
            check=true;
          }
        }
      }
    }
    if(check){
      alert("This destination is already in the want-to-go list");
    }
    else {
      db.collection("myCollection").updateOne({Username : loggedUser},{$push:{list:"Inca"}});
    }

})
  })
});

app.get('/annapurna',function(req,res){
  if(loggedin) {
    res.render('annapurna')  
  }
  else {
    res.redirect('/')
  }
 
})

app.post('/annapurna',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
      if(err) throw err;
    var check = false;
    for(let i = 0; i<myCollection.length;i++) {
      if(loggedUser==myCollection[i].Username) {
        var goto=myCollection[i].list;
        for(let y = 0 ; y<goto.length;y++) {
          if(goto[y]=="Annapurna") {
            check=true;
          }
        }
      }
    }
    if(check){
      alert("This destination is already in the want-to-go list");
    }
    else {
      db.collection("myCollection").updateOne({Username : loggedUser},{$push:{list:"Annapurna"}});
    }

})
  })
});

//cities
app.get('/cities',function(req,res){
  if(loggedin) {
    res.render('cities')  
  }
  else {
    res.redirect('/')
  }
});

app.get('/paris',function(req,res){
  if(loggedin) {
    res.render('paris')  
  }
  else {
    res.redirect('/')
  }
});

app.post('/paris',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
      if(err) throw err;
    var check = false;
    for(let i = 0; i<myCollection.length;i++) {
      if(loggedUser==myCollection[i].Username) {
        var goto=myCollection[i].list;
        for(let y = 0 ; y<goto.length;y++) {
          if(goto[y]=="Paris") {
            check=true;
          }
        }
      }
    }
    if(check){
      alert("This destination is already in the want-to-go list");
    }
    else {
      db.collection("myCollection").updateOne({Username : loggedUser},{$push:{list:"Paris"}});
    }

})
  })
});



app.get('/rome',function(req,res){
  if(loggedin) {
    res.render('rome')  
  }
  else {
    res.redirect('/')
  }
})

app.post('/rome',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
      if(err) throw err;
    var check = false;
    for(let i = 0; i<myCollection.length;i++) {
      if(loggedUser==myCollection[i].Username) {
        var goto=myCollection[i].list;
        for(let y = 0 ; y<goto.length;y++) {
          if(goto[y]=="Rome") {
            check=true;
          }
        }
      }
    }
    if(check){
      alert("This destination is already in the want-to-go list");
    }
    else {
      db.collection("myCollection").updateOne({Username : loggedUser},{$push:{list:"Rome"}});
    }

})
  })
});

//islands
app.get('/islands',function(req,res){
  if(loggedin) {
    res.render('islands')  
  }
  else {
    res.redirect('/')
  }
})

app.get('/bali',function(req,res){
  if(loggedin) {
    res.render('bali')  
  }
  else {
    res.redirect('/')
  }})

app.post('/bali',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
      if(err) throw err;
    var check = false;
    for(let i = 0; i<myCollection.length;i++) {
      if(loggedUser==myCollection[i].Username) {
        var goto=myCollection[i].list;
        for(let y = 0 ; y<goto.length;y++) {
          if(goto[y]=="Bali") {
            check=true;
          }
        }
      }
    }
    if(check){
      alert("This destination is already in the want-to-go list");
    }
    else {
      db.collection("myCollection").updateOne({Username : loggedUser},{$push:{list:"Bali"}});
    }

})
  })
});

app.get('/santorini',function(req,res){
  if(loggedin) {
    res.render('santorini')  
  }
  else {
    res.redirect('/')
  }})

app.post('/santorini',function(req,res){
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
      if(err) throw err;
    var check = false;
    for(let i = 0; i<myCollection.length;i++) {
      if(loggedUser==myCollection[i].Username) {
        var goto=myCollection[i].list;
        for(let y = 0 ; y<goto.length;y++) {
          if(goto[y]=="Santorini") {
            check=true;
          }
        }
      }
    }
    if(check){
      alert("This destination is already in the want-to-go list");
    }
    else {

      db.collection("myCollection").updateOne({Username : loggedUser},{$push:{list:"Santorini"}});
    }

})
  })
});


app.get('/wanttogo',function(req,res){
 if(loggedin) {
   const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({Username:loggedUser}).toArray(function(err,myCollection){
      res.render('wanttogo',{title:myCollection[0].list});
})
  }) }
  else {
    res.redirect('/')
  }
});

app.post('/wanttogo',async(req,res)=> {
  const cookies = req.cookies;
  const loggedUser = cookies['loggedUser'];
  var d = [];
  MongoClient.connect("mongodb://127.0.0.1:27017",async function(err,client){
    if(err) throw err;
    var db = client.db('myDB');
    db.collection("myCollection").find({}).toArray(function(err,myCollection){
     if(err) throw err;
      for(let i = 0; i<myCollection.length;i++){
        if(myCollection[i].Username==loggedUser) {
          var goto=myCollection[i].list;
          for(let y= 0; y<goto.length;y++) {
            d.push(goto[y])
          }

        }}
      

})
  })
  res.render('wantogo',{d});
});


app.get('/search',function(req,res){
  if(loggedin) {
    res.render('searchresults')  
  }
  else {
    res.redirect('/')
  }
})

app.post('/search',function(req,res){
  const s = req.body.Search
  const d = ["annapurna","rome","bali","paris","santorini","inca"];
  const r = new Array("","","","","","");
  const l = new Array("","","","","","");

  for(let i = 0; i < d.length;i++) {
    if (d[i].toLowerCase().includes(s.toLowerCase())) {
      r[i]=d[i];
  }
  else {
      r[i]="";
  }
}
  for( let i = 0 ; i<l.length;i++) {
   if(r[i].toLowerCase().includes("rome")) {
    l[i]="rome";
   }
   else if (r[i].toLowerCase().includes("annapurna")) {
    l[i]="annapurna";
  }
  else if (r[i].toLowerCase().includes("paris")) {
    l[i]="paris";
  }
  else if (r[i].toLowerCase().includes("inca")) {
    l[i]="inca";
  }
  else if (r[i].toLowerCase().includes("santorini")) {
    l[i]="santorini";
  }
  else if (r[i].toLowerCase().includes("bali")) {
    l[i]="bali";
  }
  else {
    l[i]="";
  }
}
res.render('searchresults',{
  l1:l[0],r1:r[0],
  l2:l[1],r2:r[1],
  l3:l[2],r3:r[2],
  l4:l[3],r4:r[3],
  l5:l[4],r5:r[4],
  l6:l[5],r6:r[5],
})

});


app.listen(3000);
