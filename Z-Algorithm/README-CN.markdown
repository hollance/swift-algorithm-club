# Z 算法字符串搜索

目标：用 Swift 写一个简单的线性时间的字符串匹配算法来返回给定模式在字符串中的出现的所有索引。
 
换句话说，想要实现 `String` 的一个扩展 `indexesOf(pattern: String)` 返回整数数组 `[Int]`，表示的是搜索模式在字符串中出现的索引，或者如果没有找到任何匹配的话返回 `nil`。
 
例如：

```swift
let str = "Hello, playground!"
str.indexesOf(pattern: "ground")   // Output: [11]

let traffic = "🚗🚙🚌🚕🚑🚐🚗🚒🚚🚎🚛🚐🏎🚜🚗🏍🚒🚲🚕🚓🚌🚑"
traffic.indexesOf(pattern: "🚑") // Output: [4, 21]
```

许多字符串搜索算法都会使用一个预处理函数来得到一个在后续步骤里会使用到的表格。这个表格在模式搜索的时候能够节省时间，因为它可以避免不必要的字符比较。[Z 算法](README-CN.markdown) 是其中一个函数。它是作为模式预处理函数（这就是它在 [Knuth-Morris-Pratt 算法](../Knuth-Morris-Pratt/README-CN.markdown) 和其他算法里的角色）而诞生的，但是，就像我们这里展示的一样，它也可以用来做简单的字符串搜索算法。

### Z 算法作为模式预处理

就像我们前面说的，Z 算法最开始是为了计算跳过比较表而用来处理模式的算法。
Z 算法对模式 `P` 的计算会生成一个整数数组（写做 `Z`），数组里的每个元素，`Z[i]`，表示的是从 `i` 开始的并且与 `P` 的前缀匹配的最长子串的长度。简单来说或， `Z[i]`  记录的是与前缀 `P` 匹配的最长的 `P[i...|P|]` 的前缀。举个例子来所，假设 `P = "ffgtrhghhffgtggfredg"`。那么就有 `Z[5] = 0 (f...h...)`, `Z[9] = 4 (ffgtr...ffgtg...)` 和 `Z[15] = 1 (ff...fr...)`。
但是我们怎么计算 `Z` 呢？在描述算法之前我们先要介绍一下 Z 盒子的概念。Z 盒子是在计算时用到的一对 `(left, right)`，用来记录子串中与 `P` 的前缀匹配的最长子串的长度。`left` 和 `right` 这两个索引分别表示这个子串的左边和右边的索引。
Z 算法的定义是由归纳得出的，对于模式里的每一个位置 `k` 它都会计算得出数组中的元素，从 `k = 1` 开始。 (`Z[k + 1]`, `Z[k + 2]`, ...) 的值是在 `Z[k]` 之后计算的。这个算法背后的思想是前面已经计算的值可以加速计算 `Z[k + 1]` 的值，可以避免一些已经做了的字符比较。看看这个例子，假设我们已经迭代到 `k = 100` 了，我们正在分析模式的第 `100` 的位置。所有 `Z[1]` 和 `Z[99]` 之间的值已经计算正确了并且 `left = 70` 和 `right = 120`。这就是说有一个长度为 `51` 的子串，从位置 `70` 开始，在位置 `120` 结束与我们要处理的模式/字符串的前缀匹配。基于这个我们可以知道从 `100` 开始的长度为 `21` 的子串与从 `30` 开始的长度为 `21` 的模式的子串是匹配的（因为我们是在与模式的前缀匹配的子串里面）。所以可以在不需要额外的字符对比的情况下用 `Z[30]` 来计算 `Z[100]` 。
这是这个算法背后的思想的简单描述。当已计算好的值不能直接用时就就需要做一些比较了。

下面是计算 Z 数组方法的代码：

```swift
func ZetaAlgorithm(ptrn: String) -> [Int]? {

    let pattern = Array(ptrn.characters)
    let patternLength: Int = pattern.count

    guard patternLength > 0 else {
        return nil
    }

    var zeta: [Int] = [Int](repeating: 0, count: patternLength)

    var left: Int = 0
    var right: Int = 0
    var k_1: Int = 0
    var betaLength: Int = 0
    var textIndex: Int = 0
    var patternIndex: Int = 0

    for k in 1 ..< patternLength {
        if k > right {  // Outside a Z-box: compare the characters until mismatch
            patternIndex = 0

            while k + patternIndex < patternLength  &&
                pattern[k + patternIndex] == pattern[patternIndex] {
                patternIndex = patternIndex + 1
            }

            zeta[k] = patternIndex

            if zeta[k] > 0 {
                left = k
                right = k + zeta[k] - 1
            }
        } else {  // Inside a Z-box
            k_1 = k - left + 1
            betaLength = right - k + 1

            if zeta[k_1 - 1] < betaLength { // Entirely inside a Z-box: we can use the values computed before
                zeta[k] = zeta[k_1 - 1]
            } else if zeta[k_1 - 1] >= betaLength { // Not entirely inside a Z-box: we must proceed with comparisons too
                textIndex = betaLength
                patternIndex = right + 1

                while patternIndex < patternLength && pattern[textIndex] == pattern[patternIndex] {
                    textIndex = textIndex + 1
                    patternIndex = patternIndex + 1
                }

                zeta[k] = patternIndex - k
                left = k
                right = patternIndex - 1
            }
        }
    }
    return zeta
}
```

我们举个例子来用上面的代码来推理一下。假设字符串是 `P = “abababbb"`。算法从 `k = 1`，`left = right = 0` 开始，所以 Z 盒子还没有激活，因为 `k > right`，就从比较 `P[1]` and `P[0]` 开始。
  
    
       01234567
    k:  x
       abababbb
       x
    Z: 00000000
    left:  0
    right: 0

一开始我们得到的是一个不匹配的比较，因为从 `P[1]` 开始的子串与 `P` 的前缀不匹配。所以，`Z[1] = 0`，并且 `left` 和 `right` 不变。开始另一个 `k = 2` 的迭代，2 > 0 ，所以继续比较 `P[2]` 和 `P[0]` 字符。这次，字符匹配了，然后我们就继续对比直到出现不匹配。在位置 `6` 的时候出现了。匹配的字符数是 `4`，所以 `Z[2] = 4`，`left = k = 2` 和 `right = k + Z[k] - 1 = 5`。我们有了第一个 Z 盒子，它的子串是 `"abab"`（注意，它是与 `P` 的前缀匹配的），它是从 `left = 2` 开始的。

       01234567
    k:   x
       abababbb
       x
    Z: 00400000
    left:  2
    right: 5

然后处理 `k = 3`。`3 <= 5`，我们在之前找到的 Z 盒子的内部并且在 P 的前缀里。所以我们可以查找一个在之前计算的值里的位置。`k_1 = k - left = 1`，这就是与 `P[k]` 相等的字符的索引。然后检查 `Z[1] = 0` 和 `0 < (right - k + 1 = 3)`，发现我们正好还在 Z 盒子里。我们可以使用之前计算好的值，所以 `Z[3] = Z[1] = 0`, `left` 和 `right` 依然保持不变。
在 `k = 4` 的迭代的时候，我们开始就执行了外层 `if` 的 `else` 分支。在里面的 `if` 里有 `k_1 = 2` 和 `(Z[2] = 4) >= 5 - 4 + 1`。所以子串 `P[k...r]` 与 `P` 的前缀 `right - k + 1 = 2` 的字符匹配，但是它不是后面的字符，我们还需要比较从 `r + 1 = 6` 开始的和从 `right - k + 1 = 2` 开始的字符。`P[6] != P[2]`，所以 `Z[k] = 6 - 4 = 2`, `left = 4` 和 `right = 5`。

       01234567
    k:     x
       abababbb
       x
    Z: 00402000
    left:  4
    right: 5

`k = 5` 的时候，`k <= right` 并且 `(Z[k_1] = 0) < (right - k + 1 = 1)`，所以 `z[k] = 0`。在迭代 `6` 和 `7` 的时候，我们执行了外层 if 的第一个分支但是没有匹配，所以算法就结束了，返回 `Z = [0, 0, 4, 0, 2, 0, 0, 0]`。

Z 算法是线性时间的。更确切的说，对于大小为 `n` 的字符串 `P`，Z 算法的时间是 `O(n)`。

作为字符串预处理的 Z 算法的实现是 [ZAlgorithm.swift](./ZAlgorithm.swift) 文件里。

### Z 算法 用作字符串搜索算法

上面讨论的 Z 算法就是最简单的线性时间的字符串匹配算法了。为了获得这个，我们需要简单的将模式 `P` 和文本 `T` 合并成一个字符串 `S = P$T`，其中 `$` 是既没有出现在 `P` 又没有出现在 `T` 中的字符。然后我们对 `$` 运行这个算法来活的 Z 数组。我们现在要做的所有事情就是扫描 Z 数组来查找和 `n` （模式的长度）相等的元素。当我们找到这样的值的时候就可以报告说有匹配。

```swift
extension String {

    func indexesOf(pattern: String) -> [Int]? {
        let patternLength: Int = pattern.characters.count
        /* Let's calculate the Z-Algorithm on the concatenation of pattern and text */
        let zeta = ZetaAlgorithm(ptrn: pattern + "💲" + self)

        guard zeta != nil else {
            return nil
        }

        var indexes: [Int] = [Int]()

        /* Scan the zeta array to find matched patterns */
        for i in 0 ..< zeta!.count {
            if zeta![i] == patternLength {
                indexes.append(i - patternLength - 1)
            }
        }

        guard !indexes.isEmpty else {
            return nil
        }

        return indexes
    }
}
```

举个例子。假设 `P = “CATA“`， `T = "GAGAACATACATGACCAT"`是模式和文本。将这两个合并到一起组成一个 `$` 得到 `S = "CATA$GAGAACATACATGACCAT"`。对 `S` 应用 Z 算法之后得到：

                1         2
      01234567890123456789012
      CATA$GAGAACATACATGACCAT
    Z 00000000004000300001300
                ^

然后扫描 Z 数组，在位置 10 的位置发现 `Z[10] = 4 = n`。所以我们可以报告说在文本位置 `10 - n - 1 = 5` 的地方有一个匹配。

就像之前说的，这个算法的复杂度是线性的。定义 `n` 和 `m` 为模式和文本的长度，最后我们得到的复杂度是 `O(n + m + 1) = O(n + m)`。


参考： 代码是基于这本书的 ["Algorithm on String, Trees and Sequences: Computer Science and Computational Biology"](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) by Dan Gusfield, Cambridge University Press, 1997. 

*作者：Matteo Dunnhofer 翻译：Daisy*


