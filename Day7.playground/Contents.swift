

func makePizza(addToppings: (Int) -> Void) {
    print("The dough is ready.")
    print("The base is flat.")
    addToppings(4)
}

makePizza { (toppingCount: Int) in
    let toppings = ["ham", "salami", "onions", "peppers"]
    for i in 0..<toppingCount {
        let topping = toppings[i]
        print("I'm adding \(topping)")
    }
}

func study(reviseNotes: (String) -> Void) {
    let notes = "Napoleon was a short, dead dude."
    for _ in 1...10 {
        reviseNotes(notes)
    }
}
study { (notes: String) in
    print("I'm reading my notes: \(notes)")
}

func activateAI(_ ai: () -> String) {
    print("Let's see what this thing can do...")
    let result = ai()
    print(result)
}
activateAI {
    return "Come with me if you want to live."
}
