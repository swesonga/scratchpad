/*
* Test code for comparing how MSVC and Clang build LLVM Flang using the C++17 standard.
*
* - MSVC 19.32.31332 for x64 fails when line 157 is commented out.
* - Apple clang 13.1.6 (clang-1316.0.21.2.5) target: arm64-apple-darwin21.2.0 compiles it just fine
*   using "clang++ -std=c++17 flang-msvc-clang-test.cpp"
*
* Test case author: Saint Wesonga
*/

#include <functional>
#include <optional>
#include <variant>

using namespace std;

template <typename A> class FunctionRef { };

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L430
template <typename T> using Scalar = typename std::decay_t<T>::Scalar;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Common/Fortran.h#L22
enum class TypeCategory { Integer, Real, Complex, Character, Logical, Derived };

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/integer.h#L52
template <int BITS>
class Integer {
public:
	// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/integer.h#L112
	// Constructors and value-generating static functions
	constexpr Integer() { } // default constructor: zero
	constexpr Integer(const Integer&) = default;
	constexpr Integer(Integer&&) = default;

	// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/integer.h#L117
	// C++'s integral types can all be converted to Integer
	// with silent truncation.
	template <typename INT, typename = std::enable_if_t<std::is_integral_v<INT>>>
	constexpr Integer(INT n) {
	}

	// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/integer.h#L391
	constexpr int LEADZ() const {
		return 0;
	}
};

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L47
// Specific intrinsic types are represented by specializations of
// this class template Type<CATEGORY, KIND>.
template <TypeCategory CATEGORY, int KIND = 0> class Type;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L258
template <int KIND>
class Type<TypeCategory::Integer, KIND> {
public:
	using Scalar = ::Integer<8 * KIND>;
};

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Common/visit.h#L69
template <typename VISITOR, typename... VARIANT>
inline auto visit2(VISITOR&& visitor, VARIANT &&...u)
-> decltype(visitor(std::get<0>(std::forward<VARIANT>(u))...)) {
	using Result = decltype(visitor(std::get<0>(std::forward<VARIANT>(u))...));
	return ::std::visit(
		std::forward<VISITOR>(visitor), std::forward<VARIANT>(u)...);
}

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Common/template.h#L132
// CombineTuples takes a list of std::tuple<> template instantiation types
// and constructs a new std::tuple type that concatenates all of their member
// types.  E.g.,
//   CombineTuples<std::tuple<char, int>, std::tuple<float, double>>
// is std::tuple<char, int, float, double>.
template <typename... TUPLES> struct CombineTuplesHelper {
	static decltype(auto) f(TUPLES *...a) {
		return std::tuple_cat(std::move(*a)...);
	}
	using type = decltype(f(static_cast<TUPLES*>(nullptr)...));
};
template <typename... TUPLES>
using CombineTuples = typename CombineTuplesHelper<TUPLES...>::type;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L58
// A predicate that is true when a kind value is a kind that could possibly
// be supported for an intrinsic type category on some target instruction
// set architecture.
// TODO: specialize for the actual target architecture
static constexpr bool IsValidKindOfIntrinsicType(
	TypeCategory category, std::int64_t kind) {
	switch (category) {
	case TypeCategory::Integer:
		return kind == 1 || kind == 2 || kind == 4 || kind == 8 || kind == 16;
	default:
		return false;
	}
}

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L322
// For each intrinsic type category CAT, CategoryTypes<CAT> is an instantiation
// of std::tuple<Type<CAT, K>> that comprises every kind value K in that
// category that could possibly be supported on any target.
template <TypeCategory CATEGORY, int KIND>
using CategoryKindTuple =
std::conditional_t<IsValidKindOfIntrinsicType(CATEGORY, KIND),
	std::tuple<Type<CATEGORY, KIND>>, std::tuple<>>;

template <TypeCategory CATEGORY, int... KINDS>
using CategoryTypesHelper =
::CombineTuples<CategoryKindTuple<CATEGORY, KINDS>...>;

template <TypeCategory CATEGORY>
using CategoryTypes = CategoryTypesHelper<CATEGORY, 1, 2, 3, 4, 8, 10, 16, 32>;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Common/template.h#L204
// Given a type function, MapTemplate applies it to each of the types
// in a tuple or variant, and collect the results in a given variadic
// template (typically a std::variant).
template <template <typename> class, template <typename...> class, typename...>
struct MapTemplateHelper;
template <template <typename> class F, template <typename...> class PACKAGE,
	typename... Ts>
struct MapTemplateHelper<F, PACKAGE, std::tuple<Ts...>> {
	using type = PACKAGE<F<Ts>...>;
};
template <template <typename> class F, typename TUPLEorVARIANT,
	template <typename...> class PACKAGE = std::variant>
using MapTemplate =
typename MapTemplateHelper<F, PACKAGE, TUPLEorVARIANT>::type;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/common.h#L227
template <typename A> class Expr { };

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L363
// Represents a type of any supported kind within a particular category.
template <TypeCategory CATEGORY> struct SomeKind { };

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L386
// Represents any derived type, polymorphic or not, as well as CLASS(*).
template <>
class SomeKind<TypeCategory::Derived> {
};

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/expression.h#L756
// A polymorphic expression of known intrinsic type category, but dynamic
// kind, represented as a discriminated union over Expr<Type<CAT, K>>
// for each supported kind K in the category.
template <TypeCategory CAT>
class Expr<SomeKind<CAT>> {
public:
	using Result = SomeKind<CAT>;
	::MapTemplate<Expr, CategoryTypes<CAT>> u;
};

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/common.h#L229
class FoldingContext { };

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/type.h#L418
using SomeInteger = SomeKind<TypeCategory::Integer>;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/lib/Evaluate/fold-implementation.h#L451
// helpers to fold intrinsic function references
// Define callable types used in a common utility that
// takes care of array and cast/conversion aspects for elemental intrinsics

template <typename TR, typename... TArgs>
using ScalarFunc = std::function<Scalar<TR>(const Scalar<TArgs> &...)>;

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/include/flang/Evaluate/expression.h#L517
template <int KIND>
class Expr<Type<TypeCategory::Integer, KIND>> {
public:
	using Result = Type<TypeCategory::Integer, KIND>;
};

// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/lib/Evaluate/fold-integer.cpp#L487
template <int KIND>
Expr<Type<TypeCategory::Integer, KIND>> FoldIntrinsicFunction(
	FoldingContext& context,
	FunctionRef<Type<TypeCategory::Integer, KIND>>&& funcRef) {
	using T = Type<TypeCategory::Integer, KIND>;

	// https://github.com/llvm/llvm-project/blob/c0702ac07b8e206f424930ff0331151954fb821c/flang/lib/Evaluate/fold-integer.cpp#L749
	const Expr<SomeInteger>* sExpr{ nullptr };
	return ::visit2(
		[&](const auto& n) -> Expr<T> {
			using TI = typename std::decay_t<decltype(n)>::Result;

			auto fptr{ &Scalar<TI>::LEADZ };

			auto lambda = ScalarFunc<T, TI>([&](const Scalar<TI>& i) -> Scalar<T> {
				return Scalar<T>{std::invoke(fptr, i)};
				});

			Expr<T>* someExpr{ nullptr };
			return *someExpr;
		},
		sExpr->u);
}

int main()
{
	FoldingContext foldingContext;

	FunctionRef<Type<TypeCategory::Integer, 2>> funcRefInteger;
	auto someIntVal = FoldIntrinsicFunction(foldingContext, std::move(funcRefInteger));

	return 0;
}