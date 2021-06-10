// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

#include <CTOML/CTOML.h>
#include "toml.hpp"
#include "Conversion.hpp"

#ifdef __cplusplus
extern "C" {
#endif

	// MARK: - Creation and Deletion

	/// Initializes a new \c toml::array .
	CTOMLArray * arrayCreate() {
		return reinterpret_cast<CTOMLArray *>( new toml::array() );
	}

	// MARK: - Array Information

	/// Checks whether \c array1 is equal to \c array2 .
	/// @param array1 This first \c toml::array that will be used in the comparison.
	/// @param array2 This second \c toml::array that will be used in the comparison.
	bool arrayEqual(CTOMLArray * array1, CTOMLArray * array2) {
		auto arr1 = *reinterpret_cast<toml::array *>(array1);
		auto arr2 = *reinterpret_cast<toml::array *>(array2);
		return arr1 == arr2;
	}

	/// Whether \c array is empty or not.
	bool arrayIsEmpty(CTOMLArray * array) {
		return reinterpret_cast<toml::array *>(array)->empty();
	}

	/// The amount of elements in \c array .
	size_t arraySize(CTOMLArray * array) {
		return reinterpret_cast<toml::array *>(array)->size();
	}

	/// Clears all the values in \c array .
	/// @param array The \c toml::array to clear.
	void arrayClear(CTOMLArray * array) {
		reinterpret_cast<toml::array *>(array)->clear();
	}

	// MARK: - Value Insertion

	/// Insert a \c bool into \c array .
	void arrayInsertBool(CTOMLArray * array, int64_t index, bool boolean) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, boolean);
	}

	/// Insert a \c int64_t into \c array .
	void arrayInsertInt(CTOMLArray * array, int64_t index, int64_t integer, uint8_t flags) {

		auto v = toml::value { integer };

		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, integer);

		arr->get(index)->as_integer()->flags(toml::value_flags { flags });
	}

	/// Insert a \c double into \c array .
	void arrayInsertDouble(CTOMLArray * array, int64_t index, double d) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, d);
	}

	/// Insert a \c char* into \c array .
	void arrayInsertString(CTOMLArray * array, int64_t index, const char * _Nonnull string) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, string);
	}

	/// Insert a \c CTOMLDate into \c array .
	void arrayInsertDate(CTOMLArray * array, int64_t index, CTOMLDate date) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, cTOMLDateToTomlDate(date));
	}

	/// Insert a \c CTOMLTime into \c array .
	void arrayInsertTime(CTOMLArray * array, int64_t index, CTOMLTime time) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, cTOMLTimeToTomlTime(time));
	}

	/// Insert a \c CTOMLDateTime into \c array .
	void arrayInsertDateTime(CTOMLArray * array, int64_t index, CTOMLDateTime dateTime) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, cTOMLDateTimeToTomlDateTime(dateTime));
	}

	/// Insert a \c toml::table into \c array .
	void arrayInsertTable(CTOMLArray * array, int64_t index, CTOMLTable * _Nonnull table) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, *reinterpret_cast<toml::table *>(table));
	}

	/// Insert a \c toml::array into \c array .
	void arrayInsertArray(CTOMLArray * array, int64_t index, CTOMLArray * _Nonnull array2) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->insert(arr->cbegin() + index, *reinterpret_cast<toml::array *>(array2));
	}

	// MARK: - Value Retrieval
	
	/// Retrieves a \c toml::node from \c array at \c index .
	CTOMLNode * _Nullable arrayGetNode(CTOMLArray * array, int64_t index) {
		auto arr = reinterpret_cast<toml::array *>(array);
		if (arr->get(index)) {
			return reinterpret_cast<CTOMLNode *>( arr->get(index) );
		} else {
			return NULL;
		}
	}

	// MARK: - Value Removal

	/// Removes the element at \c index from \c array .
	void arrayRemoveElement(CTOMLArray * array, int64_t index) {
		auto arr = reinterpret_cast<toml::array *>(array);
		arr->erase(arr->cbegin() + index);
	}

#ifdef __cplusplus
}
#endif
