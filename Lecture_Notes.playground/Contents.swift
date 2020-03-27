

// MARK: ARC
//AUTOMATIC REFERENCE COUNTING
//Kepps track of references of each created object in memory

//if an object has a reference value bigger than 1 it can not be deallocated from memory
//if this is not handled it can create memory leaks

class Developer {
    let name: String
    var machine: MacBook?
    
    init(name: String) {
        self.name = name
    }
}

class MacBook {
    let serialNumber: Int
    var owner: Developer?
    
    init(serialNumber: Int){
        self.serialNumber = serialNumber
    }
}

// this created object has a reference of 1 in memory
//if this object get deleted or gets out of scope its reference count goes to 0
//therefore it get deallocated from memory (ARC deals with it)
var sean: Developer? = Developer(name: "Sean")
var spaceGreyMBP: MacBook = MacBook(serialNumber: 23)

// MARK: Strong References
//if two or more object have values associated with each other it is called STRONG REFERENCE
//as the example beloow where sean has as machine property another object and/or
//MacBook has as an owner property an instance of another object
//in this case the object reference in memory for each of these two object will be 2

//it is 2 because "sean" has a strong reference to itself + "spaceGreyMBP" has a strong reference to "sean" so "sean" has a value of 2
//same thing goes for the "spaceGreyMBP" object

spaceGreyMBP.owner = sean
sean?.machine = spaceGreyMBP

// MARK: The Problem
//in this case if "sean" goes out of scope / gets deleted ecc its reference count will not go to 0 but to 1
//because "spaceGreyMBP's" reference of "sean" stil exists in memory

// MARK: The Solution
//When declaring the class with the property we know that will have a reference to another object
//we declare this property with "week" in front of it. This creates a week reference.
//the count of reference in memory for this object doesn't get higher if we reference it from another object
//and when we delete it its rederence from 1 goes to 0

class Developer1 {
    let name: String
    weak var machine: MacBook1?
    
    init(name: String) {
        self.name = name
    }
}

class MacBook1 {
    let serialNumber: Int
    weak var owner: Developer1?
    
    init(serialNumber: Int){
        self.serialNumber = serialNumber
    }
}

var sean1: Developer1? = Developer1(name: "Sean")
var spaceGreyMBP1: MacBook1 = MacBook1(serialNumber: 23)

spaceGreyMBP1.owner = sean1
sean1?.machine = spaceGreyMBP1
