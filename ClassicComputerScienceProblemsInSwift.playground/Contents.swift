//: Playground - noun: a place where people can play
import Foundation

func fib2(n: UInt) -> UInt {
    if (n < 2) {
        return n;
    }
    return fib2(n: n - 2) + fib2(n: n - 1)
}

fib2(n: 5)
fib2(n: 10)

var fibMemo: [UInt: UInt] = [0: 0, 1: 1]
func fib3(n: UInt) -> UInt {
    if let result = fibMemo[n] {
        return result
    }
    else {
        fibMemo[n] = fib3(n: n - 1) + fib3(n: n - 2)
    }
    return fibMemo[n]!
}

func fib4(n: UInt) -> UInt {
    if (n == 0) {
        return n
    }
    var last: UInt = 0, next: UInt = 1
    for _ in 1..<n {
        (last, next) = (next, last + next)
    }
    return next
}

struct CompressedGene {
    let length: Int
    private let bitVector: CFMutableBitVector
    
    init(original: String) {
        length = original.characters.count
        // default allocator, need 2 * length number of bits
        bitVector = CFBitVectorCreateMutable(kCFAllocatorDefault, length * 2) // fills the bit vector with 0s
        compress(gene: original)
        
    }
    
    private func compress(gene: String) {
        for (index, nucleotide) in gene.uppercased().characters.enumerated() {
            let nStart = index * 2 // start of each new nucleotide
            switch nucleotide {
            case "A": // 00
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "C": // 01
                CFBitVectorSetBitAtIndex(bitVector, nStart, 0)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            case "G": // 10
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 0)
            case "T": // 11
                CFBitVectorSetBitAtIndex(bitVector, nStart, 1)
                CFBitVectorSetBitAtIndex(bitVector, nStart + 1, 1)
            default:
                print("Unexcpected character \(nucleotide) at \(index)")
            }
        }
    }
    
    func decompress() -> String {
        var gene: String = ""
        for index in 0..<length {
            let nStart = index * 2 // start of each nucleotide
            let firstBit = CFBitVectorGetBitAtIndex(bitVector, nStart)
            let secondBit = CFBitVectorGetBitAtIndex(bitVector, nStart + 1)
            switch (firstBit, secondBit) {
                case (0, 0): // 00 A
                    gene += "A"
                case (0, 1): // 01 C
                    gene += "C"
                case (1, 0): // 10 G
                    gene += "G"
                case (1, 1): // 11 T
                    gene += "T"
                default:
                    break // unreachable, but need default
            }
        }
        return gene
    }
}

print(CompressedGene(original: "ATGAATGCC").decompress())