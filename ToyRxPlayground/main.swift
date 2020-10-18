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

example(of: "toArray") {
    let bag = DisposeBag()
    
    Observable.of("a", "b", "c")
        .toArray()
        .subscribe(onSuccess: {
            print($0)
        })
        .disposed(by: bag)
}

example(of: "map") {
    let bag = DisposeBag()
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    Observable<Int>.of(123, 4, 56)
        .map {
            formatter.string(for: $0) ?? ""
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
}

example(of: "enumerated and map") {
    let bag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map { index, integer in
            index > 2 ? integer * 2 : integer
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
}

example(of: "compactMap") {
    let bag = DisposeBag()
    
    Observable.of("to", "be", nil, "or", "not", "to", "be", nil)
        .compactMap { $0 }
        .toArray()
        .map({ $0.joined(separator: " " )})
        .subscribe(onSuccess: {
            print($0)
        })
        .disposed(by: bag)
}

struct Student {
    let score: BehaviorSubject<Int>
}

example(of: "flatMap") {
    let bag = DisposeBag()
    
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    
    let student = PublishSubject<Student>()
    
    student
        .flatMap { $0.score }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
    
    student.onNext(laura)
    laura.score.onNext(85)
    
    student.onNext(charlotte)
    charlotte.score.onNext(100)
}

example(of: "flatMapLatest") {
    let bag = DisposeBag()
    
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 90))
    
    let student = PublishSubject<Student>()
    
    student
        .flatMapLatest { $0.score }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
    
    student.onNext(laura)
    laura.score.onNext(85)
    student.onNext(charlotte)
    
    laura.score.onNext(95)
    charlotte.score.onNext(100)
}

example(of: "materialize and dematerialize") {
    let bag = DisposeBag()
    
    let laura = Student(score: BehaviorSubject(value: 80))
    let charlotte = Student(score: BehaviorSubject(value: 100))
    
    let student = BehaviorSubject(value: laura)
    
    let studentScore = student
        .flatMapLatest {
            $0.score.materialize()
        }
    
    studentScore
        .filter {
            guard $0.error == nil else {
                print($0.error!)
                return false
            }
            
            return true
        }
        .dematerialize()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
    
    laura.score.onNext(85)
    laura.score.onError(MyError.anError)
    laura.score.onNext(90)
    
    student.onNext(charlotte)
}
