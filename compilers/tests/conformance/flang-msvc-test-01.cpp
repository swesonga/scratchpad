/*
* Extracted test code for investigating MSVC warnings when using the C++17 standard.
*
* - MSVC 19.34.31823.3 for x64 fails with this warning on line 86:
*       warning C4927: illegal conversion; more than one user-defined conversion has been implicitly applied
*
*   Compile using
*       cl /c /TP /WX /std:c++17 /permissive- flang-msvc-test-01.cpp
*/

#include <vector>

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Common/reference.h#L16
#include <type_traits>

template <typename A> class Reference {
public:
    using type = A;
    Reference(type& x) : p_{ &x } {}
    Reference(const Reference& that) : p_{ that.p_ } {}
    Reference(Reference&& that) : p_{ that.p_ } {}
    Reference& operator=(const Reference& that) {
        p_ = that.p_;
        return *this;
    }
    Reference& operator=(Reference&& that) {
        p_ = that.p_;
        return *this;
    }

    // Implicit conversions to references are supported only for
    // const-qualified types in order to avoid any pernicious
    // creation of a temporary copy in cases like:
    //   Reference<type> ref;
    //   const Type &x{ref};  // creates ref to temp copy!
    operator std::conditional_t<std::is_const_v<type>, type&, void>()
        const noexcept {
        if constexpr (std::is_const_v<type>) {
            return *p_;
        }
    }

    type& get() const noexcept { return *p_; }
    type* operator->() const { return p_; }
    type& operator*() const { return *p_; }

    bool operator==(std::add_const_t<A>& that) const {
        return p_ == &that || *p_ == that;
    }
    bool operator!=(std::add_const_t<A>& that) const { return !(*this == that); }
    bool operator==(const Reference& that) const {
        return p_ == that.p_ || *this == *that.p_;
    }
    bool operator!=(const Reference& that) const { return !(*this == that); }

private:
    type* p_; // never null
};
template <typename A> Reference(A&)->Reference<A>;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Semantics/symbol.h#L40
class Symbol;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Semantics/symbol.h#L43
using SymbolRef = Reference<const Symbol>;
using SymbolVector = std::vector<SymbolRef>;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Semantics/symbol.h#L684
class Symbol {
private:
    Symbol() {} // only created in class Symbols
public:
    Symbol(const Symbol&) {}
};

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/lib/Semantics/expression.cpp#L1157
SymbolVector reversed;

int main()
{
    // https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/lib/Semantics/expression.cpp#L1190
    if (!reversed.empty()) {
        // https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/lib/Semantics/expression.cpp#L1192
#define WARNME
#ifdef WARNME
        const Symbol& symbol{ reversed.front() };
#else
        auto theSymbolRef = reversed.front();
        auto theSymbol = *theSymbolRef;
        const Symbol& symbol{ theSymbol };
#endif
    }
}
