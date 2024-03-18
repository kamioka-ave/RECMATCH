// @flow
import type { Company } from '../../models/companies/Company';
import type { Supporter } from '../../models/supporters/Supporter';
import type { Staff } from '../../models/staffs/Staff';

export type Member = Supporter | Company | Staff;
