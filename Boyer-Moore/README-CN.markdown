# Boyer-Moore 字符串搜索

目标：不导入 `Foundation` 或者使用 `NSString` 的 `rangeOfString()`方法的情况下用纯 Swift 写一个字符串搜索算法。

换句话说，我们想要实现一个 `String` 的 `indexOf(pattern: String)` 扩展，返回第一个出现的搜索词的 `String.Index`，如果在字符串里没有找到的话就返回 `nil`。

例如:

```swift
// Input:
let s = "Hello, World"
s.indexOf(pattern: "World")

// Output:
<String.Index?> 7

// Input:
let animals = "🐶🐔🐷🐮🐱"
animals.indexOf(pattern: "🐮")

// Output:
<String.Index?> 6
```

> **注意：** 牛的索引是 6，而不是看到的 3，因为 emoji 使用了更多的存储空间。`String.Index` 的实际值并不是很重要，重点是要指向字符串中正确的字符。

[暴力方式](../Brute-Force%20String%20Search/README-CN.markdown) 能够很好的工作，但是不够有效，尤其是有一大段文本的时候。就像上面看到的，我们不需要查找源字符串中的 _每个_ 字符——可以跳过多个字符。

跳过头部算法叫做 [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer–Moore_string_search_algorithm) ，这个算法已经存在有很长一段时间。它被认为是所有字符串搜索算法的标杆。

下面是 Swift 中的实现：

```swift
extension String {
    func index(of pattern: String) -> Index? {
        // 先缓存需要搜索的字符串的长度
        // 因为在后面我们会经常用到它，每次都计算的话就不太划算了。
        let patternLength = pattern.characters.count
        guard patternLength > 0, patternLength <= characters.count else { return nil )
      
        // 做一个位移表。这个表用来在当找到了一个匹配的字符串的时候告诉我们要位移多远
        var skipTable = [Character: Int]()
        for (i, c) in pattern.characters.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

        // 指向搜索词里的最后一个字符
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]

      
        // 从右到左开始扫描，所以先跳过搜索词的长度。（减 1 是因为 startIndex 已经指向了源字符串的第一个字符）
        var i = index(startIndex, offsetBy: patternLength - 1)
        
        // 这是一个辅助方法，用来从两个字符串的后面往前找，直到找到一个不匹配的字符，或者是直到搜索词的开始
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }

        // 主循环。一直找，知道字符串的结尾
        while i < endIndex {
            let c = self[i]

            // 当前字符是否与搜索词里的最后一个字符匹配
            if c == lastChar {

                // 找到了一个匹配。继续往后做 brute-force 搜索
                if let k = backwards() { return k }

                // 如果没有匹配的，我们只要安全的往前移动一个字符
                i = index(after: i)
            } else {
                // 字符不匹配，所以要跳过。要跳过的数量是由位移表决定的。
                // 如果字符串没有在搜索词中出现，我们可以跳过整个搜索词的长度
                // 然而，如果字符在搜索词中出现了，前面可能有一个匹配，所以我们不能位移太多
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

算法是像下面这样工作的。将源字符串和需要搜索的字符串对齐，然后看看哪个字符与要匹配的字符串的 _最后_ 一个字符匹配：

```
source string:  Hello, World
search pattern: World
                    ^
```

有三中可能：

1. 两个字符相等，找到了一个可能的匹配。

2. 字符不相等，但是字符在搜索词中出现过。

3. 字符根本没有在搜索词中出现。

在这个例子中，字符 `o` 和 `d` 不匹配，但是 `o` 出现在了搜索词中。也就是说我们跳过一些位置：

```
source string:  Hello, World
search pattern:    World
                       ^
```

现在两个 `o` 字符已经对齐了。现在我们将搜索词中的最后一个字符 `d` 和 `W` 做对比。他们是不相等的，但是 `W` 出现在了搜索词中。所以再移动几个位置以使 `W` 对齐：

```
source string:  Hello, World
search pattern:        World
                           ^
```

现在这两个字符是相等的，然后就有了一个可能的匹配。为了验证这个匹配，再做一次 brute-force 搜索，不是是往后的，从搜索词的最后到开始，然后全部找到了。

任何时候位移的数量是由 “位移表” 决定的，它是一个字典，里面包含了搜索方式中的每个字符以及他们对应的的位移个数。位移表看起来就是下面这样的：

```
W: 4
o: 3
r: 2
l: 1
d: 0
```

字符越靠近搜索词的尾部，要位移的数量就越少。如果字符在搜索词中出现了多次，最靠近搜索词尾部的字符决定着要移动的数量。

> **注意：** 如果搜索词是由很少的字符串组成，做一次 brute-force 搜索是很快的。在对短搜索词建立位移表和做  brute-force 搜索的时候会有一个取舍。

参考: 上面的代码是基于Dr Dobb's 杂志上的这篇文章 [Costas Menico 更快的字符串搜索](http://www.drdobbs.com/database/faster-string-searches/184408171) , 七月 1989 -- 是的, 1989！有时候保留这些古老的杂志是很有用的。
参考: [算法的详细分析](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm)

## Boyer-Moore-Horspool algorithm

上面算法的一个变种是 [Boyer-Moore-Horspool 算法](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm)。

跟一般的 Boyer-Moore 算法相同的是，它使用 `位移表` 来跳过一些字符。不同的地方在于怎么检查部分匹配。在上面的版本中，如果找到了一个部分匹配但不是完全匹配，我们只跳过一个字符。在这个更聪明的版本中，我们一样使用位移表来处理上面的情况。

下面是一个  Boyer-Moore-Horspool 算法的实现：

```swift
extension String {
    func index(of pattern: String) -> Index? {
        // 先缓存需要搜索的字符串的长度
        // 因为在后面我们会经常用到它，每次都计算的话就不太划算了。
        let patternLength = pattern.characters.count
        guard patternLength > 0, patternLength <= characters.count else { return nil }

        // 简历位移表。这个表决定在找到匹配字符之后需要位移的数量
        var skipTable = [Character: Int]()
        for (i, c) in pattern.characters.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

        // 指向搜索词的最后一个字符
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]

        // 从右到左扫描搜索词，所以先跳过搜索词的长度。（减 1 是因为 startIndex 已经指向了源字符串的第一个字符）
        var i = index(startIndex, offsetBy: patternLength - 1)

        // 这是一个辅助方法，从后往前搜索两个字符串，直到我们找一个不匹配的字符，或者是到了搜索词的开始。
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }

        // 主循环，直到源字符串的结尾
        while i < endIndex {
            let c = self[i]

            // 当前字符串是否与搜索词的最后一个字符匹配
                if c == lastChar {

                // 有一个匹配，从后面开始做 brute-force 搜索
                if let k = backwards() { return k }

                // 确保最少要跳过一个字符（因为位移表中的第一个字符的位移是 `skipTable[lastChar] = 0` ）
                let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
            } else {
                // 字符不匹配，所以要跳过。要跳过的数量是由位移表决定的。
                // 如果字符串没有在搜索词中出现，我们可以跳过整个搜索词的长度
                // 然而，如果字符在搜索词中出现了，前面可能有一个匹配，所以我们不能位移太多
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

在实际中，Horspool 看起来表现要比原来的版本更好一些。然而，这是由你想要做的取舍决定的。

参考: 代码是基于这篇论文: [R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)

_作者：Matthijs Hollemans, Andreas Neusüß， [Matías Mazzei](https://github.com/mmazzei) 更新，翻译：Daisy_.


