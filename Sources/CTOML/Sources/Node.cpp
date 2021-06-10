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

	/// The TOML type of \c node .
	CTOMLNodeType nodeType(CTOMLNode * node) {
 		auto type = reinterpret_cast<toml::node *>(node)->type();

		switch (type) {
			case toml::v2::node_type::array:
				return CTOMLNodeType { array };
				break;
			case toml::v2::node_type::boolean:
				return CTOMLNodeType { boolean };
				break;
			case toml::v2::node_type::date:
				return CTOMLNodeType { date };
				break;
			case toml::v2::node_type::date_time:
				return CTOMLNodeType { dateTime };
				break;
			case toml::v2::node_type::floating_point:
				return CTOMLNodeType { floatingPoint };
				break;
			case toml::v2::node_type::integer:
				return CTOMLNodeType { integer };
				break;
			case toml::v2::node_type::string:
				return CTOMLNodeType { string };
				break;
			case toml::v2::node_type::table:
				return CTOMLNodeType { table };
				break;
			case toml::v2::node_type::time:
				return CTOMLNodeType { timeType };
				break;
			default:
				// FIXME: This shouldn't happen.
				return CTOMLNodeType { string };
		}
	}

	// MARK: - Value Retrieval

	/// Retrieves a \c bool from the \c node .
	const bool * _Nullable nodeAsBool(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_boolean();

		if (res == NULL) {
			return NULL;
		}

		auto boolMem = (bool *)malloc(sizeof(bool));

		memcpy(boolMem, &res->get(), sizeof(bool));

		return boolMem;
	}

	/// Retrieves a \c int64_t from the \c node .
	const int64_t * _Nullable nodeAsInt(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_integer();

		if (res == NULL) {
			return NULL;
		}

		auto intMem = (int64_t *)malloc(sizeof(int64_t));

		memcpy(intMem, &res->get(), sizeof(int64_t));

		return intMem;
	}

	/// Retrieves a \c double from the \c node .
	const double * _Nullable nodeAsDouble(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_floating_point();

		if (res == NULL) {
			return NULL;
		}

		auto doubleMem = (double *)malloc(sizeof(double));

		memcpy(doubleMem, &res->get(), sizeof(double));

		return doubleMem;
	}

	/// Retrieves a \c char * from the \c node .
	const char * _Nullable nodeAsString(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_string();

		if (res == NULL) {
			return NULL;
		}

		return strdup(res->get().c_str());
	}

	/// Retrieves a \c CTOMLDate from the \c node .
	const CTOMLDate * _Nullable nodeAsDate(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_date();

		if (res == NULL) {
			return NULL;
		}

		auto date = res->get();

		auto dateMem = (CTOMLDate *)malloc(sizeof(CTOMLDate));

		CTOMLDate cTOMLDate = tomlDateToCTOMLDate(date);

		memcpy(dateMem, &cTOMLDate, sizeof(CTOMLDate));

		return dateMem;
	}

	/// Retrieves a \c CTOMLTime from the \c node .
	const CTOMLTime * _Nullable nodeAsTime(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_time();

		if (res == NULL) {
			return NULL;
		}

		auto time = res->get();

		auto timeMem = (CTOMLTime *)malloc(sizeof(CTOMLTime));

		CTOMLTime cTOMLTime = tomlTimeToCTOMLTime(time);

		memcpy(timeMem, &cTOMLTime, sizeof(CTOMLTime));

		return timeMem;
	}

	/// Retrieves a \c CTOMLDateTime from the \c node .
	const CTOMLDateTime * _Nullable nodeAsDateTime(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_date_time();

		if (res == NULL) {
			return NULL;
		}

		auto dateTime = res->get();

		auto dateTimeMem = (CTOMLDateTime *)malloc(sizeof(CTOMLDateTime));

		CTOMLDateTime cTOMLDateTime = tomlDateTimeToCTOMLDateTime(dateTime);

		memcpy(dateTimeMem, &cTOMLDateTime, sizeof(CTOMLDateTime));

		return dateTimeMem;
	}

	/// Retrieves a \c CTOMLTable from the \c node .
	CTOMLTable * _Nullable nodeAsTable(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_table();

		if (res == NULL) {
			return NULL;
		}

		return reinterpret_cast<CTOMLTable *>(res);
	}

	/// Retrieves a \c CTOMLArray from the \c node .
	CTOMLArray * _Nullable nodeAsArray(CTOMLNode * _Nonnull node) {
		auto res = reinterpret_cast<toml::node *>(node)->as_array();

		if (res == NULL) {
			return NULL;
		}

		return reinterpret_cast<CTOMLArray *>(res);
	}



#ifdef __cplusplus
}
#endif
