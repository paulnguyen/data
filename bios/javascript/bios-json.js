
// Hello World JavaScript
// alert( "Hello JavaScript" ) ;
console.log( "Hello JavaScript" ) ;

// JS Arrays
var array1 = [1, 2, 3, 4]
var array2 = ["one", "two", "three", "four"]
var array3 = [ array1, array2 ]
console.log ( array1 ) ;
console.log ( array2 ) ;
console.log ( array3 ) ;

// JS Objects 
var person = new Object();
person.firstname = "John";
person.lastname = "Doe";  
person.getFullName = function(){
    console.log (person.firstname+' '+person.lastname);
};
person.getFullName();

// Hello World JSON
var json = { "Hello" : "Hello World #1" } ;
console.log(json.Hello) ;
console.log(json["Hello"]) ;

// Hello World JS Object - Literal Notation
var jsobj = { Hello : "Hello World #2" } ;
console.log( jsobj.Hello ) ;
console.log( jsobj["Hello"] ) ;

// Hello World JS Object - Constructor Notation
var jsobj2 = new Object() ;
jsobj2.Hello = "Hello World #3" ;
console.log( jsobj2.Hello ) ;

// Hello World JS Object - Constructor Function
function HelloClass(msg) {
  this.Hello = msg;
}
var jsobj3 = new HelloClass("Hello World #4") ;
console.log( jsobj3.Hello ) ;


// JSON Object
 var json_person = {
    "id": 101,
    "name": "John Doe",
    "isStudent": true,
    "scores": [
        10,
        20,
        30,
        40
    ],
    "courses": {
        "major": "Finance",
        "minor": "Marketing"
    }
} ;
json_person;


// JS Object
var js_person = {
    id: 101,
    name: "John Doe",
    isStudent: true,
    scores: [
        10,
        20,
        30,
        40
    ],
    courses: {
        "major": "Finance",
        "minor": "Marketing"
    },
    printName: function() {
        console.log( this.name ) ;
    }
}
js_person;



//  JSON Supports Data Types:  strings, numbers, booleans, arrays, objects, and null
var stringVal = "Hello World" ;
var numberVal = 1234 ;
var booleanVal = true ;
var arrayVal = [ 1, 2, 3 ] ;
var objectVal = { "id" : "123", "name" : "Jonh Smith" }
var nullVal1 = "" ;
var nullVal2 = null ;
console.log( "String = " + stringVal + "  // type = " + typeof(stringVal) ) ;
console.log( "Number = " + numberVal + " // type = " + typeof(numberVal) ) ;
console.log( "Boolean = " + booleanVal + " // type = " + typeof(booleanVal) ) ;
console.log( "Array = " + arrayVal + " // type = " + typeof(arrayVal) ) ;
console.log( "Object = " + objectVal + " // type = " + typeof(objectVal) ) ;
console.log( "Null Val1 = " + nullVal1 + " // type = " + typeof(nullVal1) ) ;
console.log( "Null Val2 = " + nullVal2 + " // type = " + typeof(nullVal2) ) ;



// BIOS Example
var john =
{
    "name" : {
        "first" : "John",
        "last" : "Backus"
    },
 	"birth" : new Date(1924,12-1,03),
    "death" : new Date(2007,03-1,17),   
    "contribs" : [
        "Fortran",
        "ALGOL",
        "Backus-Naur Form",
        "FP"
    ],
    "awards" : [
        {
            "award" : "W.W. McDowell Award",
            "year" : 1967,
            "by" : "IEEE Computer Society"
        },
        {
            "award" : "National Medal of Science",
            "year" : 1975,
            "by" : "National Science Foundation"
        },
        {
            "award" : "Turing Award",
            "year" : 1977,
            "by" : "ACM"
        },
        {
            "award" : "Draper Prize",
            "year" : 1993,
            "by" : "National Academy of Engineering"
        }
    ]    
} ;


//
// REF:  	http://www.json.org/
// TOOLS:	https://jsonformatter.curiousconcept.com/
// MODEL:	http://www.objgen.com/
//




