//
//  main.swift
//  ToyRxPlayground
//
//  Created by AD0502 on 16/10/2020.
//

import Foundation
import RxSwift
import RxRelay

enum MyError: Error {
    case anError
}

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    
    subject.on(.next("is anyone listening?"))
    
    let subscriptionOne = subject.subscribe(onNext: { string in
        print(string)
    })
    
    subject.on(.next("1"))
    subject.on(.next("2"))
    
    let subscriptionTwo = subject
        .subscribe { event in
            print("2), ", event.element ?? event)
        }
    
    subject.on(.next("3"))
    
    subscriptionOne.dispose()
    
    subject.on(.next("4"))
    
    subject.onCompleted()
    
    subject.on(.next("5"))
    
    subscriptionTwo.dispose()
    
    let disposeBag = DisposeBag()
    
    subject.subscribe {
        print("3) ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
    
    subject.on(.next("?"))
}

example(of: "BehaviorSubject") {
    let subject = BehaviorSubject(value: "initial value")
    let disposeBag = DisposeBag()
    
    subject.subscribe {
        print(label: "1)", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject.onNext("X")
    
    subject.onError(MyError.anError)
    
    subject.subscribe {
        print(label: "2) ", event: $0)
    }
    .disposed(by: disposeBag)
}

example(of: "ReplaySubject") {
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject.subscribe {
        print(label: "1) ", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject.subscribe {
        print(label: "2) ", event: $0)
    }
    .disposed(by: disposeBag)
    
    subject.onNext("4")
    
    subject.onError(MyError.anError)
    subject.dispose()
    
    subject.subscribe {
        print(label: "3) ", event: $0)
    }
    .disposed(by: disposeBag)
}

example(of: "PublishRelay") {
    let relay = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    relay.accept("knock, knock, anyone hoome?")
    
    relay.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
    
    relay.accept("1")
}

example(of: "BehaviorRelay") {
    let relay = BehaviorRelay(value: "initial value")
    let disposeBag = DisposeBag()
    
    relay.accept("new initial value")
    
    relay.subscribe {
        print(label: "1) ", event: $0)
    }
    .disposed(by: disposeBag)
    
    relay.accept("1")
    
    relay.subscribe {
        print(label: "2) ", event: $0)
    }
    .disposed(by: disposeBag)
    
    relay.accept("2")
    
    print(relay.value)
}
