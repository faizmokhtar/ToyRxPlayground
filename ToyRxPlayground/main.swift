//
//  main.swift
//  ToyRxPlayground
//
//  Created by AD0502 on 16/10/2020.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum MyError: Error {
    case anError
}

example(of: "startWith") {
    let numbers = Observable.of(2, 3, 4)
    
    let observable = numbers.startWith(1)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "Observable.concat") {
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)
    
    let observable = Observable.concat([first, second])
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
    
    let observable = germanCities.concat(spanishCities)
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "concatMap") {
    let sequences = [
        "German cities": Observable.of("Berlin", "Munich", "Frankfurt"),
        "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
    ]
    
    let observable = Observable.of("German cities", "Spanish cities")
        .concatMap({ country in sequences[country] ?? .empty() })
    
    _ = observable.subscribe(onNext: { string in
        print(string)
    })
}

example(of: "merge") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let source = Observable.of(left.asObservable(), right.asObservable())
    
    let observable = source.merge()
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    var leftValues = ["Berlin", "Munich", "Frankfurt"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]
    
    repeat {
        switch Bool.random() {
        case true where !leftValues.isEmpty:
        left.onNext("Left: " + leftValues.removeFirst())
        case false where !rightValues.isEmpty:
            right.onNext("Right: " + rightValues.removeFirst())
        default:
            break
        }
    } while !leftValues.isEmpty || !rightValues.isEmpty

    left.onCompleted()
    right.onCompleted()
}

example(of: "combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let observable = Observable.combineLatest(left, right) {
        lastLeft, lastRight in
        "\(lastLeft) \(lastRight)"
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    print("> Sending a value to Left")
    left.onNext("Hello, ")
    print("> Sending a value to Right")
    right.onNext("world")
    print("> Sending another value to Right")
    right.onNext("RxSwift")
    print("> Sending another value to Left")
    left.onNext("Have a good day,")
    
    left.onCompleted()
    right.onCompleted()
}

example(of: "combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
    let dates = Observable.of(Date())
    
    let observable = Observable.combineLatest(choice, dates) {
        format, when -> String in
        let formatter = DateFormatter()
        formatter.dateStyle  = format
        return formatter.string(from: when)
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "zip") {
    enum Weather {
        case cloudy
        case sunny
    }
    
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
    let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
    
    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)"
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "withLatestFrom") {
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    
    let observable = button.withLatestFrom(textField)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
}

example(of: "amb") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    
    let observable = left.amb(right)
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // will only relay elements from the first active observable
    right.onNext("Kuala Lumpur")
    left.onNext("Lisbon")
    right.onNext("Copenhagen")
    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")

    left.onCompleted()
    right.onCompleted()
}

example(of: "switchLatest") {
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    
    let source = PublishSubject<Observable<String>>()
    
    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    
    source.onNext(one)
    one.onNext("some text from sequence one")
    two.onNext("some text from sequence two")
    
    source.onNext(two)
    two.onNext("more text from sequence two")
    one.onNext("and also from sequence one")
    
    source.onNext(three)
    two.onNext("why don't you see me?")
    one.onNext("i'm alone, help me")
    three.onNext("hey it's three. I win.")

    source.onNext(one)
    one.onNext("nope. It's me, one!")
    
    disposable.dispose()
}

example(of: "reduce") {
    let source = Observable.of(1, 2, 3, 4, 5, 6)
    
    let observable = source.reduce(0) { summary, newValue in
        return summary + newValue
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "scan") {
    let source = Observable.of(1, 2, 3, 4, 5, 6)

    let observable = source.scan(0) { summary, newValue in
        return summary + newValue
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}
